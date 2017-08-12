require_relative "../users_spec"

module Users
  RSpec.describe "User auth" do
    def store_with(records)
      FakeStore.new(records)
    end

    def get_user(id, store)
      Users.get_user(id, store)
    end

    it "returns the current user for the stored user id in the session" do
      record = {id: "user-1234", email: "b@e.com", first_name: "Benito"}
      store = store_with([record])
      user = get_user(record[:id], store)
      expect(user.id).to eq "user-1234"
      expect(user.email).to eq "b@e.com"
      expect(user.first_name).to eq "Benito"
    end

    it "knows if the user is a wedding planner" do
      record = {id: "user-1234", email: "b@e.com", first_name: "Benito", user_type: "wedding_planner"}
      store = store_with([record])
      user = get_user(record[:id], store)
      expect(user).to be_wedding_planner

      record = {id: "user-1234", email: "b@e.com", first_name: "Benito", user_type: "groom"}
      store = store_with([record])
      user = get_user(record[:id], store)
      expect(user).not_to be_wedding_planner
    end
  end
end
