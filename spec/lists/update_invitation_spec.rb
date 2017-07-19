require_relative "../lists_spec"

module Lists
  describe "Updated invitation" do
    def store_with(records)
      FakeInvitationsStore.new(records)
    end

    it "new invitation" do
      id = rand(100)
      store = store_with([{id: id, title: "Uno", guests: "Benito, Maripaz", email: "bh@x.com"}])
      form = Lists.get_edit_invitation_form(id, store)
      expect(form.title).to eq "Uno"
      expect(form.phone).to eq nil
      expect(form.email).to eq "bh@x.com"
      expect(form.guests).to eq "Benito, Maripaz"
    end

    it "has the group options" do
      id = rand(100)
      store = store_with([
        {id: id, group: "uno"},
        {group: "uno"},
        {group: "dos"}
      ])

      form = Lists.get_edit_invitation_form(id, store)
      expect(form.group_options).to eq ["uno", "dos"]
    end

    it "updates the record" do
      id = rand(100)
      store = store_with([{id: id}])
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
      store = store_with([{id: id}])
      params = {
        "title" => "",
        "guests" => "Benito, Maripaz",
        "phone" => "1234-1234",
        "email" => "bh@example.com"
      }

      expect(store).not_to receive(:update)

      status = Lists.update_invitation(id, params, store)
      expect(status).not_to be_success

      form = status.form
      expect(form.errors[:title]).to eq "no puede estar en blanco"
      expect(form.title).to eq ""
      expect(form.guests).to eq "Benito, Maripaz"
      expect(form.group).to eq nil
      expect(form.phone).to eq "1234-1234"
      expect(form.email).to eq "bh@example.com"
      expect(form.group_options).to eq []
    end
  end
end
