require "active_support/all"
require_relative "validations"

module Users
  def self.register_form
    Registration.form
  end

  def self.register_user(data, config)
    Registration.register_user(data, config)
  end

  def self.login_form
    Login.form
  end

  def self.login(data, config)
    Login.login(data, config)
  end

  def self.sign_out(config)
    config.fetch(:session_store).remove_user_id
  end

  def self.user?(config)
    config.fetch(:session_store).user_id?
  end

  def self.guest?(config)
    !config.fetch(:session_store).user_id?
  end

  def self.get_current_user(config)
    store = config.fetch(:store)
    session_store = config.fetch(:session_store)
    build_user(store.find(session_store.user_id))
  end

  def self.get_user(id, store)
    build_user(store.find(id))
  end

  def self.build_user(record)
    User.new(record)
  end

  def self.get_users_list(users_store, lists_store)
    lists = lists_store.all.map { |data| List.new(data) }.group_by(&:user_id)
    users_store.all.map do |data|
      user = User.new(data)
      UserWithListsCount.new(user, lists[user.id] || [])
    end
  end

  def self.send_password_recovery_instructions(params, mailer, token_generator, store)
    email = params["email"]

    if email.blank?
      return ErrorStatus.new("Por favor ingresa un email")
    end

    if record = store.find_by_email(email)
      user = User.new(record)
      token_field = :password_recovery_token
      store.update(user.id, token_field => token_generator.call(user.id, token_field))
      mailer.send_password_recovery_instructions(user.id)
      SuccessStatus
    else
      ErrorStatus.new("El email no esta registrado")
    end
  end

  def self.get_password_recovery_token(user_id, store)
    store.find(user_id)[:password_recovery_token]
  end

  def self.find_by_password_recovery_token(token, store)
    User.new(store.find_by_password_recovery_token(token))
  end

  def self.update_password(token, params, config)
    store, encryptor, session_store = config.values_at(:store, :encryptor, :session_store)

    if params["password"].blank?
      return ErrorStatus.new("La contraseña no puede estar en blanco")
    end

    if params["password"] != params["password_confirmation"]
      return ErrorStatus.new("La confirmación no coincide con la contraseña")
    end

    user = find_by_password_recovery_token(token, store)
    store.update(user.id, password_hash: encryptor.encrypt(params["password"]))
    session_store.save_user_id(user.id)
    SuccessStatus
  end

  class List
    attr_reader :list_id, :user_id
    def initialize(data)
      @list_id = data[:list_id]
      @user_id = data[:user_id]
    end
  end

  class User
    attr_reader :id, :email, :first_name, :last_name, :created_at

    def initialize(data)
      @id = data[:id]
      @email = data[:email]
      @user_type = data[:user_type]
      @first_name = data[:first_name]
      @last_name = data[:last_name]
      @created_at = data[:created_at]
    end

    def full_name
      [first_name, last_name].compact.join(" ")
    end

    def wedding_planner?
      @user_type == "wedding_planner"
    end
  end

  class UserWithListsCount < SimpleDelegator
    attr_reader :lists_count

    def initialize(user, lists)
      super(user)
      @lists_count = lists.count
    end
  end

  class ErrorStatus
    attr_reader :error

    def initialize(error)
      @error = error
    end

    def success?
      false
    end
  end

  class SuccessStatus
    def self.success?
      true
    end
  end

  module Login
    def self.form
      Form.new
    end

    def self.login(data, store:, encryptor:, session_store:)
      error = ErrorStatus.new("Email o contraseña inválidos")
      return error unless user = find_user(data, store)
      return error unless valid_password?(data, user, encryptor)
      session_store.save_user_id(user[:id])
      SuccessStatus
    end

    def self.find_user(data, store)
      store.find_by_email(data["email"])
    end

    def self.valid_password?(data, user, encryptor)
      encryptor.password?(user[:password_hash], data["password"])
    end

    class Form
      attr_reader :email, :password

      def initialize(data = {})
        @email = data[:email]
        @password = data[:password]
      end
    end
  end

  module Registration
    def self.form
      Form.new
    end

    def self.register_user(data, store:, encryptor:, session_store:)
      form = Form.new(data)
      errors = Validator.new(form, store).errors
      return (form.add_errors(errors) and ErrorWithForm.new(form)) if errors.any?
      user = create_record(form, store, encryptor)
      session_store.save_user_id(user[:id])
      SuccessStatus
    end

    def self.create_record(form, store, encryptor)
      store.save(
        first_name: form.first_name,
        last_name: form.last_name,
        org_name: form.org_name,
        email: form.email,
        user_type: form.user_type,
        password_hash: encryptor.encrypt(form.password)
      )
    end

    class ErrorWithForm
      attr_reader :form

      def initialize(form)
        @form = form
      end

      def success?
        false
      end
    end

    class Validator
      include Validations

      def initialize(form, store)
        @form = form
        @store = store
      end

      def errors
        [validate_confirmation,
         validate_uniqueness_of_email,
         *validate_presence_of(form, *form.required_fields)]
          .compact.to_h
      end

      private

      attr_reader :form, :store

      def validate_confirmation
        unless form.password == form.password_confirmation
          [:password_confirmation, "no coincide"]
        end
      end

      def validate_uniqueness_of_email
        if form.email.present? && store.find_by_email(form.email)
          [:email, "ya ha sido tomado"]
        end
      end
    end

    class Form
      ATTRS = [:first_name, :last_name, :org_name, :email, :user_type, :password, :password_confirmation]
      attr_reader *ATTRS
      attr_reader :errors

      def initialize(data = {})
        assign_attributes(data)
        @errors = {}
      end

      def fields
        ATTRS
      end

      def required_fields
        fields - [:org_name]
      end

      def add_errors(errors)
        @errors = errors
      end

      def user_type_options
        [{value: :groom, text: "Novio"},
         {value: :bride, text: "Novia"},
         {value: :other, text: "Otro"}]
      end

      private

      attr_writer *ATTRS

      def assign_attributes(data)
        ATTRS.each do |attr|
          send("#{attr}=", data[attr.to_s])
        end
      end
    end
  end
end
