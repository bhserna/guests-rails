class AddPasswordRecoveryTokenToUserRecords < ActiveRecord::Migration[5.1]
  def change
    add_column :user_records, :password_recovery_token, :string
  end
end
