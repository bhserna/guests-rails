require 'active_support/all'
require_relative "../lists_spec"

module Lists
  describe "Add invitation" do
    it "new invitation" do
      form = Lists.get_invitation_form
      expect(form.title).to eq nil
      expect(form.phone).to eq nil
      expect(form.email).to eq nil
      expect(form.guests.count).to eq 0
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

      status = Lists.add_invitation(list_id, params, store)
      expect(status).to be_success
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
      status = Lists.add_invitation(list_id, params, store)
      expect(status).not_to be_success
      expect(status.form.errors[:title]).to eq "no puede estar en blanco"
    end
  end
end
