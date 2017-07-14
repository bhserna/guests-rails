require_relative "validations"
require_relative "lists/invitation"

module Lists
  class ErrorWithForm
    attr_reader :form

    def initialize(form)
      @form = form
    end

    def success?
      false
    end
  end

  class Success
    def self.success?
      true
    end
  end

  class List
    attr_reader :id, :name, :user_id

    def initialize(data)
      @id = data[:list_id]
      @name = data[:name]
      @user_id = data[:user_id]
    end
  end

  require_relative "lists/list_creator"
  require_relative "lists/access_control"

  def self.new_list_form
    ListCreator.new_list_form
  end

  def self.create_list(*args)
    ListCreator.create_list(*args)
  end

  def self.lists_of_user(user, lists_store, people_store)
    records = lists_store.find_all_by_user_id(user.id)
    list_ids = people_store.find_ids_of_lists_with_access_for_email(user.email)
    records = (records + lists_store.find_all_by_list_ids(list_ids)).uniq
    records.map { |record| List.new(record) }
  end

  def self.get_list(list_id, lists_store)
    List.new(lists_store.find_by_list_id(list_id))
  end

  def self.current_access_details(*args)
    AccessControl.current_access_details(*args)
  end

  def self.give_access_form
    AccessControl.give_access_form
  end

  def self.give_access_to_person(*args)
    AccessControl.give_access_to_person(*args)
  end

  def self.edit_access_form(*args)
    AccessControl.edit_access_form(*args)
  end

  def self.update_access_for_person(*args)
    AccessControl.update_access_for_person(*args)
  end

  def self.remove_access_for_person(*args)
    AccessControl.remove_access_for_person(*args)
  end

  def self.has_access?(*args)
    AccessControl.has_access?(*args)
  end

  class SuccessResponse
    def self.success?
      true
    end
  end

  class ErrorResponse
    def self.success?
      false
    end
  end

  class InvitationForm < SimpleDelegator
    attr_reader :errors

    def initialize(invitation)
      super(invitation)
      @errors = {}
    end

    def add_errors(errors)
      @errors = errors
    end
  end

  class Validator
    extend Validations

    def self.validate(form)
      [*validate_presence_of(form, :title)].compact.to_h
    end
  end

  def self.get_invitation_form
    InvitationForm.new(Invitation.new)
  end

  def self.add_invitation(list_id, params, store)
    invitation = Invitation.new(params)
    form = InvitationForm.new(invitation)
    errors = Validator.validate(form)

    if errors.empty?
      store.create(invitation.creation_data.merge(list_id: list_id))
      SuccessResponse
    else
      form.add_errors(errors)
      ErrorWithForm.new(form)
    end
  end

  def self.get_edit_invitation_form(id, store)
    InvitationForm.new(get_invitation(id, store))
  end

  def self.update_invitation(id, params, store)
    invitation = Invitation.new(params)
    form = InvitationForm.new(invitation)
    errors = Validator.validate(form)

    if errors.empty?
      store.update(id, invitation.creation_data)
      SuccessResponse
    else
      form.add_errors(errors)
      ErrorWithForm.new(form)
    end
  end

  def self.mark_invitation_as_delivered(id, store)
    store.update(id, is_delivered: true)
  end

  def self.mark_invitation_as_not_delivered(id, store)
    store.update(id, is_delivered: false)
  end

  def self.confirm_invitation_guests_form(id, store)
    InvitationForm.new(get_invitation(id, store))
  end

  def self.confirm_invitation_guests(id, count, store)
    store.update(id, confirmed_guests_count: count.to_i, is_assistance_confirmed: true)
  end

  def self.delete_invitation(id, store)
    store.update(id, is_deleted: true)
  end

  def self.get_invitation(id, store)
    Invitation.new(store.find(id))
  end

  def self.get_invitations(list_id, store)
    store.find_all_by_list_id(list_id).map do |data|
      Invitation.new(data)
    end
  end
end
