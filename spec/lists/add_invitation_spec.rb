require 'active_support/all'
require_relative "../lists_spec"

module Lists
  describe "Add invitation" do
    def invitation_with(attrs)
      attrs.merge(id: rand(100))
    end

    def store_with(records)
      FakeInvitationsStore.new(records)
    end

    it "new invitation" do
      form = Lists.get_invitation_form(store_with([]))
      expect(form.title).to eq nil
      expect(form.phone).to eq nil
      expect(form.group).to eq nil
      expect(form.email).to eq nil
      expect(form.guests).to eq nil
    end

    it "has the group options" do
      store = store_with([
        invitation_with(group: "uno"),
        invitation_with(group: "uno"),
        invitation_with(group: "dos")
      ])

      form = Lists.get_invitation_form(store)
      expect(form.group_options).to eq ["uno", "dos"]
    end

    it "creates a record" do
      store = store_with([])
      list_id = 1234
      params = {
        "title" => "Uno",
        "guests" => "Benito, Maripaz",
        "group" => "Amigos Benito",
        "phone" => "1234-1234",
        "email" => "bh@example.com"
      }

      expect(store).to receive(:create).with({
        list_id: list_id,
        title: "Uno",
        group: "Amigos Benito",
        guests: "Benito, Maripaz",
        phone: "1234-1234",
        email: "bh@example.com"
      })

      status = Lists.add_invitation(list_id, params, store)
      expect(status).to be_success
    end

    it "needs a title" do
      store = store_with([])
      list_id = 1234
      params = {
        "title" => "",
        "guests" => "Benito, Maripaz",
        "group" => "Amigos Benito",
        "phone" => "1234-1234",
        "email" => "bh@example.com"
      }
      expect(store).not_to receive(:create)

      status = Lists.add_invitation(list_id, params, store)
      expect(status).not_to be_success

      form = status.form
      expect(form.errors[:title]).to eq "no puede estar en blanco"
      expect(form.title).to eq ""
      expect(form.guests).to eq "Benito, Maripaz"
      expect(form.group).to eq "Amigos Benito"
      expect(form.phone).to eq "1234-1234"
      expect(form.email).to eq "bh@example.com"
      expect(form.group_options).to eq []
    end
  end
end
