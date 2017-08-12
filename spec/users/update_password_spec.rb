require_relative "../users_spec"

module Users
  RSpec.describe "Update password" do
    module FakeEncryptor
      def self.encrypt(password)
        "---encripted--#{password}--"
      end
    end

    module DummySessionStore
      def self.save_user_id(id)
      end
    end

    def session_store
      DummySessionStore
    end

    def update_password(token, params, store)
      Users.update_password(token, params, store: store, encryptor: FakeEncryptor, session_store: session_store)
    end

    attr_reader :user, :token, :store

    before do
      @token = SecureRandom.uuid
      @user = {
        id: rand(100),
        first_name: "Benito",
        password_recovery_token: token
      }
      @store = FakeStore.new([user])
    end

    it "can find the user by token" do
      record = user
      user = Users.find_by_password_recovery_token(token, store)
      expect(user.id).to eq record[:id]
      expect(user.first_name).to eq record[:first_name]
    end

    describe "with good data" do
      attr_reader :data

      before do
        @data = {
          "password" => "1234secret",
          "password_confirmation" => "1234secret"
        }
      end

      it "updates the user password hash" do
        expect(store).
          to receive(:update).
          with(user[:id], password_hash: "---encripted--1234secret--")
        update_password(token, data, store)
      end

      it "returns success" do
        update = update_password(token, data, store)
        expect(update).to be_success
      end

      it "stores user id on session store" do
        expect(session_store).to receive(:save_user_id).with(user[:id])
        update_password(token, data, store)
      end
    end

    describe "without data" do
      attr_reader :data

      before do
        @data = {
          "password" => nil,
          "password_confirmation" => nil
        }
      end

      it "does not updates the record" do
        expect(store).not_to receive(:update)
        update_password(token, data, store)
      end

      it "returns blank error" do
        update = update_password(token,data, store)
        expect(update.error).to eq "La contraseña no puede estar en blanco"
      end

      it "is not success" do
        update = update_password(token,data, store)
        expect(update).not_to be_success
      end
    end

    describe "with bad password confirmation" do
      attr_reader :data

      before do
        @data = {
          "password" => "1234secret",
          "password_confirmation" => "other"
        }
      end

      it "does not updates the record" do
        expect(store).not_to receive(:update)
        update_password(token, data, store)
      end

      it "return an error" do
        update = update_password(token, data, store)
        expect(update.error).to eq "La confirmación no coincide con la contraseña"
      end

      it "is not success" do
        update = update_password(token, data, store)
        expect(update).not_to be_success
      end
    end
  end
end
