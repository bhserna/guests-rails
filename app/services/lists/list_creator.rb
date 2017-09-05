module Lists
  module ListCreator
    def self.new_list_form
      Form.new
    end

    def self.create_list(user_id, data, store, id_generator)
      form = Form.new(data)
      errors = Validator.validate(form)

      if errors.empty?
        store.save(
          list_id: id_generator.generate_id,
          user_id: user_id,
          name: data["name"])
        SuccessResponse
      else
        form.add_errors(errors)
        ErrorWithForm.new(form)
      end
    end

    def self.edit_list_name_form(list_id, store)
      Form.new(store.find_by_list_id(list_id))
    end

    def self.update_list_name(list_id, data, store)
      form = Form.new(data)
      errors = Validator.validate(form)

      if errors.empty?
        store.update_list(list_id, name: form.name)
        SuccessResponse
      else
        form.add_errors(errors)
        ErrorWithForm.new(form)
      end
    end

    class Form
      attr_reader :name, :errors

      def initialize(data = {})
        @name = data["name"] || data[:name]
        @errors = {}
      end

      def add_errors(errors)
        @errors = errors
      end
    end

    class Validator
      extend Validations

      def self.validate(form)
        [*validate_presence_of(form, :name)].compact.to_h
      end
    end
  end
end
