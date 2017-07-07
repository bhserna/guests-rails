class CreateListInvitationRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :list_invitation_records do |t|
      t.string :list_id
      t.string :title
      t.text :guests
      t.string :phone
      t.string :email
      t.boolean :is_delivered
      t.boolean :is_assistance_confirmed
      t.integer :confirmed_guests_count

      t.timestamps
    end
  end
end
