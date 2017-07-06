class CreateListRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :list_records do |t|
      t.string :list_id
      t.integer :user_id
      t.string :name

      t.timestamps
    end
  end
end
