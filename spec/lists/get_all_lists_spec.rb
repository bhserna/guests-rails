require_relative "../lists_spec"

module Lists
  RSpec.describe "Get all lists" do
    class FakeStore
      def initialize(records)
        @records = records
      end

      def all
        @records
      end
    end

    it "returns all the lists in the store" do
      users_store = FakeStore.new([
        {id: 1, email: "b@e.com", first_name: "Benito", last_name: "Serna", created_at: date = 1.month.ago},
        {id: 2, email: "m@e.com", first_name: "Maripaz", last_name: "Moreno", created_at: date},
        {id: 3, email: "e@e.com", first_name: "Emmanuel", last_name: "Serna", created_at: date}
      ])

      lists_store = FakeListsStore.new([
        {id: 1, list_id: "1234", user_id: 1, name: "Uno", created_at: date + 1.month},
        {id: 2, list_id: "3455", user_id: 1, name: "Dos", created_at: date + 1.week},
        {id: 3, list_id: "2345", user_id: 2, name: "Tres", created_at: date + 1.day}
      ])

      invitations_store = FakeInvitationsStore.new([
        {list_id: "1234"},
        {list_id: "1234"},
        {list_id: "2345"}
      ])

      third, second, first = Lists.get_all_lists(lists_store, invitations_store, users_store)
      expect(first.id).to eq "1234"
      expect(first.name).to eq "Uno"
      expect(first.created_at).to eq date + 1.month
      expect(first.user_id).to eq 1
      expect(first.user_full_name).to eq "Benito Serna"
      expect(first.invitations_count).to eq 2

      expect(second.id).to eq "3455"
      expect(second.name).to eq "Dos"
      expect(second.created_at).to eq date + 1.week
      expect(second.user_id).to eq 1
      expect(second.user_full_name).to eq "Benito Serna"
      expect(second.invitations_count).to eq 0

      expect(third.id).to eq "2345"
      expect(third.name).to eq "Tres"
      expect(third.created_at).to eq date + 1.day
      expect(third.user_id).to eq 2
      expect(third.user_full_name).to eq "Maripaz Moreno"
      expect(third.invitations_count).to eq 1
    end
  end
end
