require_relative "../users_spec"

RSpec.describe "User auth" do
  class FakeSessionStore
    attr_reader :user_id

    def initialize(data)
      @user_id = data[:user_id]
    end
  end

  class FakeStore
    def initialize(records)
      @records = records
    end

    def find(id)
      @records.detect { |r| r[:id] == id }
    end
  end

  def session_store_with(data)
    FakeSessionStore.new(data)
  end

  def store_with(records)
    FakeStore.new(records)
  end

  def get_current_user(store, session_store)
    Users.get_current_user(store: store, session_store: session_store)
  end

  it "returns the current user for the stored user id in the session" do
    record = {id: "user-1234", email: "b@e.com", first_name: "Benito"}
    store = store_with([record])
    session_store = session_store_with(user_id: record[:id])
    user = get_current_user(store, session_store)
    expect(user.id).to eq "user-1234"
    expect(user.email).to eq "b@e.com"
    expect(user.first_name).to eq "Benito"
  end

  it "knows if the user is a wedding planner" do
    record = {id: "user-1234", email: "b@e.com", first_name: "Benito", user_type: "wedding_planner"}
    store = store_with([record])
    session_store = session_store_with(user_id: record[:id])
    user = get_current_user(store, session_store)
    expect(user).to be_wedding_planner

    record = {id: "user-1234", email: "b@e.com", first_name: "Benito", user_type: "groom"}
    store = store_with([record])
    session_store = session_store_with(user_id: record[:id])
    user = get_current_user(store, session_store)
    expect(user).not_to be_wedding_planner
  end
end
