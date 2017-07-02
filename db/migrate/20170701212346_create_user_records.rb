class CreateUserRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :user_records do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :user_type
      t.string :password_hash

      t.timestamps
    end
  end
end
