require_relative "../lists_spec"

module Lists
  describe "Updated invitation" do
    it "new invitation" do
      id = rand(100)
      store = FakeInvitationsStore.new([{id: id, title: "Uno", guests: "Benito, Maripaz", email: "bh@x.com"}])
      form = Lists.get_edit_invitation_form(id, store)
      expect(form.title).to eq "Uno"
      expect(form.phone).to eq nil
      expect(form.email).to eq "bh@x.com"
      expect(form.guests).to eq "Benito, Maripaz"
    end

    it "updates the record" do
      id = rand(100)
      store = FakeInvitationsStore.new([{id: id}])
      params = {
        "title" => "Uno",
        "guests" => "Benito, Maripaz",
        "group" => "Amigos Maripaz",
        "phone" => "1234-1234",
        "email" => "bh@example.com"
      }

      expect(store).to receive(:update).with(id, {
        title: "Uno",
        guests: "Benito, Maripaz",
        group: "Amigos Maripaz",
        phone: "1234-1234",
        email: "bh@example.com"
      })

      Lists.update_invitation(id, params, store)
    end

    it "needs a title" do
      id = rand(100)
      store = FakeInvitationsStore.new([{id: id}])
      params = {
        "title" => "",
        "guests" => "Benito, Maripaz",
        "phone" => "1234-1234",
        "email" => "bh@example.com"
      }

      expect(store).not_to receive(:update)

      status = Lists.update_invitation(id, params, store)
      expect(status).not_to be_success
      expect(status.form.errors[:title]).to eq "no puede estar en blanco"
    end
  end
end
