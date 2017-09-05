require_relative "../lists_spec"

module Lists
  RSpec.describe "Edit list name" do
    def name_form(list_id, store)
      Lists.edit_list_name_form(list_id, store)
    end

    def update_list_name(list_id, data, store)
      Lists.update_list_name(list_id, data, store)
    end

    def store_with(records)
      FakeListsStore.new(records)
    end

    attr_reader :store, :list_id

    before do
      @list_id = "1234"
      @store = store_with([{list_id: list_id, name: "Uno"}])
    end

    it "has a form" do
      form = name_form(list_id, store)
      expect(form.name).to eq "Uno"
    end

    it "has no errors" do
      form = name_form(list_id, store)
      expect(form.errors).to be_empty
    end

    describe "with good data" do
      attr_reader :data

      before do
        @data = {"name" => "Nuevo nombre"}
      end

      it "updates the list with the form data" do
        expect(store).to receive(:update_list).with("1234", name: "Nuevo nombre")
        update_list_name(list_id, data, store)
      end

      it "returns success" do
        response = update_list_name(list_id, data, store)
        expect(response).to be_success
      end
    end

    describe "without data" do
      attr_reader :data

      before do
        @data = {"name" => ""}
      end

      it "does not update the record" do
        expect(store).not_to receive(:update_list)
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
