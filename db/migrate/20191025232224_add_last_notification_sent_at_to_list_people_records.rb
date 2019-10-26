class AddLastNotificationSentAtToListPeopleRecords < ActiveRecord::Migration[5.1]
  def change
    add_column :list_people_records, :last_notification_sent_at, :datetime
  end
end
