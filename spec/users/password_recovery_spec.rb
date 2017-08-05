require_relative "../users_spec"

module Users
  RSpec.describe "Password recovery" do
    def store_with(records)
    end

    describe "send password recovery instructions" do
      it "returns error if the used does not exist" do
        store = store_with([])
        params = {"email" => "user@example.com"}
        status = Users.send_password_recovery_instructions(params, store)
        expect(status).not_to be_success
        expect(status.error).to eq "El email no es válido"
      end

      it "sends an email to the user with the given email"
    end
  end
end
