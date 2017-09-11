require_relative "../lists_spec"

module Lists
  describe "Get invitation" do
    attr_reader :list_id, :store

    before do
      @list_id = 1234
      @store = FakeInvitationsStore.new([{
        list_id: 1234,
        id: 1,
        title: "Uno",
        guests: "Benito, Maripaz",
        phone: "1234-1234",
        email: "bh@example.com",
        is_delivered: true,
        confirmed_guests_count: 2,
        is_assistance_confirmed: true
      }, {
        list_id: 1234,
        id: 2,
        title: "Dos",
        guests: "Gus, Caro",
        phone: "11-1234-1234",
        group: "escuela",
        email: "g@example.com",
        is_delivered: false,
        confirmed_guests_count: 0,
        is_assistance_confirmed: false
      }, {
        list_id: 1234,
        id: 3,
        is_deleted: true
      }, {
        list_id: 12,
        id: 4
      }])
    end

    it "asks for the record" do
      invitations = Lists.get_invitations(list_id, store)
      expect(invitations.count).to eq 2

      first, second = invitations
      expect(first.id).to eq 1
      expect(first.title).to eq "Uno"
      expect(first.guests).to eq "Benito, Maripaz"
      expect(first.phone).to eq "1234-1234"
      expect(first.email).to eq "bh@example.com"
      expect(first).to be_delivered
      expect(first).to have_assistance_confirmed
      expect(first.confirmed_guests_count).to eq 2

      expect(second.id).to eq 2
      expect(second.title).to eq "Dos"
      expect(second.guests).to eq "Gus, Caro"
      expect(second.phone).to eq "11-1234-1234"
      expect(second.email).to eq "g@example.com"
      expect(second).not_to be_delivered
      expect(second).not_to have_assistance_confirmed
      expect(second.confirmed_guests_count).to eq 0
    end

    it "filter by group" do
      invitations = Lists.get_invitations(list_id, store, group: "escuela")
      expect(invitations.count).to eq 1

      second = invitations.first
      expect(second.id).to eq 2
      expect(second.guests).to eq "Gus, Caro"
    end

    describe "filter with search" do
      example do
        invitations = Lists.get_invitations(list_id, store, search: "uno")
        expect(invitations.count).to eq 1
        expect(invitations.first.id).to eq 1
        expect(invitations.first.title).to eq "Uno"
      end

      example do
        invitations = Lists.get_invitations(list_id, store, search: "dos")
        expect(invitations.count).to eq 1
        expect(invitations.first.id).to eq 2
        expect(invitations.first.title).to eq "Dos"
      end

      example do
        invitations = Lists.get_invitations(list_id, store, search: "caro")
        expect(invitations.count).to eq 1
        expect(invitations.first.id).to eq 2
        expect(invitations.first.title).to eq "Dos"
      end

      example do
        invitations = Lists.get_invitations(list_id, store, search: "Nito")
        expect(invitations.count).to eq 1
        expect(invitations.first.id).to eq 1
        expect(invitations.first.title).to eq "Uno"
      end

      example do
        invitations = Lists.get_invitations(list_id, store, search: "bh@exam")
        expect(invitations.count).to eq 1
        expect(invitations.first.id).to eq 1
        expect(invitations.first.title).to eq "Uno"
      end
    end

    describe "filter by group and search" do
      example do
        invitations = Lists.get_invitations(list_id, store, group: "escuela", search: "caro")
        expect(invitations.count).to eq 1
        expect(invitations.first.id).to eq 2
        expect(invitations.first.guests).to eq "Gus, Caro"
      end

      example do
        invitations = Lists.get_invitations(list_id, store, group: "escuela", search: "uno")
        expect(invitations.count).to eq 0
      end
    end
  end
end
