require_relative "../lists_spec"

module Lists
  describe "Confirm invitation guests" do
    def invitation_with(attrs)
      attrs.merge(id: rand(100))
    end

    def store_with(records)
      FakeInvitationsStore.new(records)
    end

    describe "form" do
      example do
        invitation = invitation_with(guests: "Benito, Maripaz", phone: "12341234", email: "b@ex.com")
        store = store_with([invitation])
        form = Lists.confirm_invitation_guests_form(invitation[:id], store)
        expect(form.phone).to eq "12341234"
        expect(form.email).to eq "b@ex.com"
        expect(form.guests).to eq "Benito, Maripaz"
        expect(form.confirmed_guests_count).to eq nil
      end

      example do
        invitation = invitation_with(confirmed_guests_count: 3, guests: "Benito, Maripaz", phone: "12341234", email: "b@ex.com")
        store = store_with([invitation])
        form = Lists.confirm_invitation_guests_form(invitation[:id], store)
        expect(form.phone).to eq "12341234"
        expect(form.email).to eq "b@ex.com"
        expect(form.guests).to eq "Benito, Maripaz"
        expect(form.confirmed_guests_count).to eq 3
      end
    end

    it "updates the record" do
      invitation = invitation_with(guests: "Benito, Maripaz")
      store = store_with([invitation])
      expect(store).to receive(:update).with(invitation[:id], {is_assistance_confirmed: true, confirmed_guests_count: 3})
      Lists.confirm_invitation_guests(invitation[:id], "3", store)
    end
  end
end
