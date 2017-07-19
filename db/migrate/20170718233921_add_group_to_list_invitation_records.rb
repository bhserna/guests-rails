class AddGroupToListInvitationRecords < ActiveRecord::Migration[5.1]
  def change
    add_column :list_invitation_records, :group, :string
  end
end
