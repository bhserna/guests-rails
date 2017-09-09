module Lists
  class Invitation
    attr_reader :id, :list_id, :title, :guests, :group, :phone, :email, :confirmed_guests_count

    def initialize(data = {})
      @id = get_value(data, :id)
      @list_id = get_value(data, :list_id)
      @title = get_value(data, :title)
      @guests = get_value(data, :guests)
      @group = get_value(data, :group)
      @phone = get_value(data, :phone)
      @email = get_value(data, :email)
      @is_deleted = get_value(data, :is_deleted)
      @is_delivered = get_value(data, :is_delivered)
      @confirmed_guests_count = get_value(data, :confirmed_guests_count)
      @is_assistance_confirmed = get_value(data, :is_assistance_confirmed)
    end

    def creation_data
      {title: title,
       phone: phone,
       group: group,
       email: email,
       guests: guests}
    end

    def deleted?
      !!@is_deleted
    end

    def delivered?
      !!@is_delivered
    end

    def has_assistance_confirmed?
      !!@is_assistance_confirmed
    end

    def guests_count
      guests.split(",").count
    end

    def match_search?(search)
      [:title, :guests, :email].any? do |attr|
        send(attr).downcase.include?(search)
      end
    end

    private

    def get_value(data, key)
      data[key] || data[key.to_s]
    end

    def get_values(data, *keys)
      keys.map {|key| get_value(data, key)}
    end
  end
end
