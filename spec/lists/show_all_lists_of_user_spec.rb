require_relative "../lists_spec"

module Lists
  RSpec.describe "Show all lists of user" do
    def lists_of_user(user, lists_store)
      Lists.lists_of_user(user, lists_store)
    end

    def list_with(data)
      data
    end

    def user_with(attrs)
      Users.build_user(attrs)
    end

    def store_with(records)
      FakeListsStore.new(records)
    end

    it "has all the records for the current user" do
      user = user_with(id: "1234", email: "current@example.com")

      lists_store = store_with([
        list_with(list_id: 1, user_id: "1234", name: "Uno"),
        list_with(list_id: 2, user_id: "1234", name: "Dos"),
        list_with(list_id: 3, user_id: "other", name: "Tres")
      ])

      first, second = all = lists_of_user(user, lists_store)

      expect(all.count).to eq 2

      expect(first.id).to eq 1
      expect(first.name).to eq "Uno"

      expect(second.id).to eq 2
      expect(second.name).to eq "Dos"
    end
  end
end
