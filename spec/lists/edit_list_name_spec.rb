require_relative "../lists_spec"

module Lists
  RSpec.describe "Edit list name" do
    class DummyStore
      def self.save(data)
      end
    end

    def name_form
      Lists.edit_name_form
    end

    def update_list_name(list_id, data, store)
      Lists.update_list_name(list_id, data, store)
    end

    it "has a form" do
      form = name_form
      expect(form.name).to eq nil
    end

    it "has no errors" do
      form = name_form
      expect(form.errors).to be_empty
    end

    describe "with good data" do
      attr_reader :data, :store, :list_id

      before do
        @store = DummyStore
        @data = {"name" => "Nuevo nombre"}
        @list_id = "1234"
      end

      it "updates the list with the form data" do
        expect(store).to receive(:update).with("1234", name: "Nuevo nombre")
        update_list_name(list_id, data, store)
      end

      it "returns success" do
        response = update_list_name(list_id, data, store)
        expect(response).to be_success
      end
    end

    describe "without data" do
      attr_reader :data, :store, :list_id

      before do
        @store = DummyStore
        @data = {"name" => ""}
        @list_id = "1234"
      end

      it "does not update the record" do
        expect(store).not_to receive(:update)
        update_list_name(list_id, data, store)
      end

      it "returns a blank name error" do
        response = update_list_name(list_id, data, store)
        expect(response.form.errors[:name]).to eq "no puede estar en blanco"
      end

      it "is not success" do
        response = update_list_name(list_id, data, store)
        expect(response).not_to be_success
      end
    end
  end
end
