require_relative "../users_spec"

RSpec.describe "Get users list" do
  class FakeStore
    def initialize(records)
      @records = records
    end

    def all
      @records
    end
  end

  it "returns all users" do
    store = FakeStore.new([
      {id: 1, email: "b@e.com", first_name: "Benito", last_name: "Serna", created_at: date = 1.month.ago},
      {id: 2, email: "m@e.com", first_name: "Maripaz", last_name: "Moreno", created_at: date},
      {id: 3, email: "e@e.com", first_name: "Emmanuel", last_name: "Serna", created_at: date}
    ])

    first, second, third = Users.get_users_list(store)
    expect(first.id).to eq 1
    expect(first.email).to eq "b@e.com"
    expect(first.full_name).to eq "Benito Serna"
    expect(first.created_at).to eq date

    expect(second.id).to eq 2
    expect(second.email).to eq "m@e.com"
    expect(second.full_name).to eq "Maripaz Moreno"
    expect(second.created_at).to eq date

    expect(third.id).to eq 3
    expect(third.email).to eq "e@e.com"
    expect(third.full_name).to eq "Emmanuel Serna"
    expect(third.created_at).to eq date
  end
end
