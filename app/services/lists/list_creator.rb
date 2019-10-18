module Lists
  module ListCreator
    def self.new_list_form
      Form.new
    end

    def self.create_list(user_id, data, store, id_generator)
      form = Form.new(data)
      errors = Validator.validate(form)

      if errors.empty?
        store.save(form.to_h.merge(
          list_id: id_generator.generate_id,
          user_id: user_id
        ))

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
      attr_reader :name, :event_date, :errors

      def initialize(data = {})
        @name = get_value(data, :name)
        self.event_date = get_value(data, :event_date)
        @errors = {}
      end

      def add_errors(errors)
        @errors = errors
      end

      def to_h
        { name: name, event_date: event_date }
      end

      private

      def event_date=(value)
        @event_date = Date.parse(value.to_s)
      rescue ArgumentError
      end

      def get_value(data, key)
        data[key.to_s] || data[key]
      end
    end

    class Validator
      extend Validations

      def self.validate(form)
        [*validate_presence_of(form, :name, :event_date)].compact.to_h
      end
    end
  end
end
