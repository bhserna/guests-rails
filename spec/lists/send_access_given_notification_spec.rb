require_relative "../lists_spec"

module Lists
  RSpec.describe "Send access given notification" do
    class DummyMailer
      def self.send_access_given_notification(person_id)
      end
    end

    Lists.mailer = DummyMailer

    def lists_store_with(records)
      FakeListsStore.new(records)
    end

    def people_store_with(records)
      FakePeopleWithAccessStore.new(records)
    end

    def mailer
      DummyMailer
    end

    def send_access_given_notification(person_id, current_time, people_store)
      Lists.send_access_given_notification(person_id, current_time, people_store)
    end

    it "sends an email to the user with access" do
      current_time = Time.now
      people_store = people_store_with([{
        id: person_id = "p-1234",
        list_id: list_id = "list-id-1234"
      }])

      expect(mailer).to receive(:send_access_given_notification).with(person_id)
      send_access_given_notification(person_id, current_time, people_store)
    end

    it "stores the time when the notification was sent" do
      current_time = Time.now
      people_store = people_store_with([{
        id: person_id = "p-1234",
        list_id: list_id = "list-id-1234"
      }])

      expect(people_store).
        to receive(:update).
        with(person_id, last_notification_sent_at: current_time)
      send_access_given_notification(person_id, current_time, people_store)
    end
  end
end
