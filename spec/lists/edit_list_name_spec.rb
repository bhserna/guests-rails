require_relative "../lists_spec"

module Lists
  RSpec.describe "Edit list" do
    def list_form(list_id, store)
      Lists.edit_list_form(list_id, store)
    end

    def update_list(list_id, data, store)
      Lists.update_list(list_id, data, store)
    end

    def store_with(records)
      FakeListsStore.new(records)
    end

    attr_reader :store, :list_id

    before do
      @list_id = "1234"
      @store = store_with([{list_id: list_id, name: "Uno", event_date: Date.new(2019, 10, 9)}])
    end

    it "has a form" do
      form = list_form(list_id, store)
      expect(form.name).to eq "Uno"
      expect(form.event_date).to eq Date.new(2019, 10, 9)
    end

    it "has no errors" do
      form = list_form(list_id, store)
      expect(form.errors).to be_empty
    end

    describe "with good data" do
      attr_reader :data

      before do
        @data = {"name" => "Nuevo nombre", "event_date" => "2019-10-9"}
      end

      it "updates the list with the form data" do
        expect(store).to receive(:update_list).with("1234", {
          name: "Nuevo nombre",
          event_date: Date.new(2019, 10, 9)
        })
        update_list(list_id, data, store)
      end

      it "returns success" do
        response = update_list(list_id, data, store)
        expect(response).to be_success
      end
    end

    describe "without data" do
      attr_reader :data

      before do
        @data = {"name" => "", "event_date" => ""}
      end

      it "does not update the record" do
        expect(store).not_to receive(:update_list)
        update_list(list_id, data, store)
      end

      it "returns a blank error" do
        response = update_list(list_id, data, store)
        expect(response.form.errors[:name]).to eq "no puede estar en blanco"
        expect(response.form.errors[:event_date]).to eq "no puede estar en blanco"
      end

      it "is not success" do
        response = update_list(list_id, data, store)
        expect(response).not_to be_success
      end
    end
  end
end
