require_relative "../app/services/lists"

module Lists
  class FakeListsStore
    def initialize(records = {})
      @records = records
    end

    def update_list(id, attrs)
    end

    def all
      @records
    end

    def find_by_list_id(id)
      @records.detect { |r| r[:list_id] == id }
    end

    def find_all_by_list_ids(ids)
      ids.map { |id| find_by_list_id(id) }
    end

    def find_all_by_user_id(user_id)
      @records.select { |r| r[:user_id] == user_id }
    end
  end

  class FakePeopleWithAccessStore
    def initialize(records)
      @records = records
    end

    def create(attrs)
    end

    def find(id)
      @records.detect { |r| r[:id] == id }
    end

    def update(id, attrs)
    end

    def delete(id)
    end

    def find_all_with_list_id(id)
      @records.select { |r| r[:list_id] == id }
    end

    def find_ids_of_lists_with_access_for_email(email)
      @records
        .select { |r| r[:email] == email }
        .map { |r| r[:list_id] }
    end
  end

  class FakeInvitationsStore
    def initialize(records = [])
      @records = records
    end

    def create(attrs)
      record = attrs.merge(id: @records.count + 1)
      @records << record
      record
    end

    def update(id, attrs)
    end

    def find(id)
      @records.detect{|r| r[:id] == id}
    end

    def find_all_groups_by_list_id(list_id)
      find_all_by_list_id(list_id).map{|r| r[:group]}.uniq.compact
    end

    def counts_by_list_id
      @records
        .group_by{|r| r[:list_id]}
        .map{|list_id, records| [list_id, records.count]}
        .to_h
    end

    def find_all_by_list_id(list_id)
      @records.select {|r| r[:list_id] == list_id}
    end
  end
end
