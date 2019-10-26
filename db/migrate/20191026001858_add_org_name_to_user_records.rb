class AddOrgNameToUserRecords < ActiveRecord::Migration[5.1]
  def change
    add_column :user_records, :org_name, :string
  end
end
