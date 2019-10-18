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

    it "returns all the lists in the store sorted by event date" do
      users_store = FakeStore.new([
        {id: 1, email: "b@e.com", first_name: "Benito", last_name: "Serna", created_at: date = Date.new(2019, 10, 9)},
        {id: 2, email: "m@e.com", first_name: "Maripaz", last_name: "Moreno", created_at: date},
        {id: 3, email: "e@e.com", first_name: "Emmanuel", last_name: "Serna", created_at: date}
      ])

      lists_store = FakeListsStore.new([
        {id: 2, list_id: "3455", user_id: 1, name: "Dos", event_date: date.next_day, created_at: date},
        {id: 1, list_id: "1234", user_id: 1, name: "Uno", event_date: nil, created_at: date},
        {id: 3, list_id: "2345", user_id: 2, name: "Tres", event_date: date.next_month, created_at: date}
      ])

      invitations_store = FakeInvitationsStore.new([
        {list_id: "1234"},
        {list_id: "1234"},
        {list_id: "2345"}
      ])

      first, second, third = Lists.get_all_lists(lists_store, invitations_store, users_store)

      expect(first.id).to eq "1234"
      expect(first.name).to eq "Uno"
      expect(first).not_to have_event_date
      expect(first.event_date).to eq nil
      expect(first.created_at).to eq date
      expect(first.user_id).to eq 1
      expect(first.user_full_name).to eq "Benito Serna"
      expect(first.invitations_count).to eq 2

      expect(second.id).to eq "3455"
      expect(second.name).to eq "Dos"
      expect(second).to have_event_date
      expect(second.event_date).to eq date.next_day
      expect(second.created_at).to eq date
      expect(second.user_id).to eq 1
      expect(second.user_full_name).to eq "Benito Serna"
      expect(second.invitations_count).to eq 0

      expect(third.id).to eq "2345"
      expect(third.name).to eq "Tres"
      expect(third).to have_event_date
      expect(third.event_date).to eq date.next_month
      expect(third.created_at).to eq date
      expect(third.user_id).to eq 2
      expect(third.user_full_name).to eq "Maripaz Moreno"
      expect(third.invitations_count).to eq 1
    end
  end
end
