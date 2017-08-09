require_relative "../app/services/users"

module Users
  class FakeStore
    def initialize(records = [])
      @records = records
    end

    def save(data)
      data
    end

    def update(id, data)
      data
    end

    def all
      @records
    end

    def find(id)
      @records.detect { |r| r[:id] == id } || raise("Not found")
    end

    def find_by_email(email)
      @records.detect { |r| r[:email] == email }
    end
  end
end
