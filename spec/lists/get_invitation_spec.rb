require_relative "../lists_spec"

module Lists
  describe "Get invitation" do
    it "asks for the record" do
      id = rand(100)
      store = FakeInvitationsStore.new([{
        id: id,
        title: "Uno",
        guests: "Benito, Maripaz",
        phone: "1234-1234",
        email: "bh@example.com",
        is_delivered: true,
        confirmed_guests_count: 2,
        is_assistance_confirmed: true,
      }])

      invitation = Lists.get_invitation(id, store)
      expect(invitation.id).to eq id
      expect(invitation.title).to eq "Uno"
      expect(invitation.guests).to eq "Benito, Maripaz"
      expect(invitation.phone).to eq "1234-1234"
      expect(invitation.email).to eq "bh@example.com"
      expect(invitation).to be_delivered
      expect(invitation).to have_assistance_confirmed
      expect(invitation.confirmed_guests_count).to eq 2
    end
  end
end
