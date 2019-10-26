class AddEventDateToListRecords < ActiveRecord::Migration[5.1]
  def change
    add_column :list_records, :event_date, :date
  end
end
