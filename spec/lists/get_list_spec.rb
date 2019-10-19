require_relative "../lists_spec"
require_relative "../users_spec"

module Lists
  RSpec.describe "Get list" do
    def lists_store_with(records)
      FakeListsStore.new(records)
    end

    def user_with(attrs)
      Users.build_user(attrs)
    end

    it "has the list info" do
      list_id = "list-id-1234"
      list = {list_id: list_id, name: "Mi super lista", event_date: Date.new(2019, 10, 9)}
      lists_store = lists_store_with([list])
      list = Lists.get_list(list_id, lists_store)
      expect(list.id).to eq list_id
      expect(list.name).to eq "Mi super lista"
      expect(list).to have_event_date
      expect(list.event_date).to eq Date.new(2019, 10, 9)
    end

    it "knows if a user is its owner" do
      list_id = "list-id-1234"
      user = user_with(id: "1234", email: "current@example.com")
      other = user_with(id: "2345", email: "other@example.com")

      list = {list_id: list_id, user_id: user.id}
      lists_store = lists_store_with([list])

      list = Lists.get_list(list_id, lists_store)
      expect(list.owner?(user)).to be
      expect(list.owner?(other)).not_to be
    end
  end
end
