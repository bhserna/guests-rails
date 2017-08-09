require_relative "../users_spec"

module Users
  RSpec.describe "Password recovery" do
    class DummyMailer
      def self.send_password_recovery_instructions(user_id)
      end
    end

    def store_with(records)
      FakeStore.new(records)
    end

    def mailer
      DummyMailer
    end

    describe "send password recovery instructions" do
      attr_reader :user_id, :token, :token_generator, :store, :params

      def send_password_recovery_instructions(params)
        Users.send_password_recovery_instructions(params, mailer, token_generator, store)
      end

      before do
        @user_id = rand(100)
        @token = SecureRandom.uuid
        @token_generator = ->(user_id, column){"#{user_id}-#{column}-#{token}"}
        @store = store_with([{id: user_id, email: "user@example.com"}])
        @params = {"email" => "user@example.com"}
      end

      it "returns error if the used does not exist" do
        params = {"email" => "other-user@example.com"}
        status = send_password_recovery_instructions(params)
        expect(status).not_to be_success
        expect(status.error).to eq "El email no es válido"
      end

      it "returns success" do
        status = send_password_recovery_instructions(params)
        expect(status).to be_success
      end

      it "stores a password recovery token" do
        expect(store).to receive(:update).
          with(user_id, password_recovery_token: "#{user_id}-password_recovery_token-#{token}")
        send_password_recovery_instructions(params)
      end

      it "sends an email to the user with the given email" do
        expect(mailer).to receive(:send_password_recovery_instructions).with(user_id)
        send_password_recovery_instructions(params)
      end
    end

    it "gets password recovery data" do
      user_id = rand(100)
      store = store_with([{id: user_id, password_recovery_token: "124"}])
      token = Users.get_password_recovery_token(user_id, store)
      expect(token).to eq "124"
    end
  end
end
