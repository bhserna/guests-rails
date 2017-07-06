require 'active_support/all'
require_relative "../lists_spec"

module Lists
  describe "Add invitation" do
    it "new invitation" do
      invitation = Lists.get_empty_invitation
      expect(invitation.title).to eq nil
      expect(invitation.phone).to eq nil
      expect(invitation.email).to eq nil
      expect(invitation.guests.count).to eq 0
    end

    it "creates a record" do
      store = FakeInvitationsStore.new
      list_id = 1234
      params = {
        "title" => "Uno",
        "guests" => [
          {"id" => 1, "name" => "Benito"},
          {"id" => 2, "name" => "Maripaz"}],
        "phone" => "1234-1234",
        "email" => "bh@example.com"
      }

      expect(store).to receive(:create).with({
        list_id: list_id,
        title: "Uno",
        guests: [{id: 1, name: "Benito"}, {id: 2, name: "Maripaz"}],
        phone: "1234-1234",
        email: "bh@example.com"
      })

      response = Lists.add_invitation(list_id, params, store)
      expect(response).to be_success
    end

    it "needs a title" do
      store = FakeInvitationsStore.new
      list_id = 1234
      params = {
        "title" => "",
        "guests" => [
          {"id" => 1, "name" => "Benito"},
          {"id" => 2, "name" => "Maripaz"}],
        "phone" => "1234-1234",
        "email" => "bh@example.com"
      }
      expect(store).not_to receive(:create)
      response = Lists.add_invitation(list_id, params, store)
      expect(response).not_to be_success
    end
  end
end
