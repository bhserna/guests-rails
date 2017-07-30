require_relative "../lists_spec"

module Lists
  describe "Get list groups" do
    def invitation_with(attrs)
      attrs.merge(id: rand(100))
    end

    def store_with(records)
      FakeInvitationsStore.new(records)
    end

    example "without groups" do
      list_id = 1234
      groups = Lists.get_list_groups(list_id, store_with([]))
    end

    example "with groups" do
      list_id = 1234
      store = store_with([
        invitation_with(list_id: list_id, group: "uno"),
        invitation_with(list_id: list_id, group: "uno"),
        invitation_with(list_id: list_id, group: "dos"),
        invitation_with(list_id: "other", group: "otro")
      ])

      groups = Lists.get_list_groups(list_id, store)
      expect(groups).to eq ["uno", "dos"]
    end
  end
end
