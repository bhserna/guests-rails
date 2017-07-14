class AddIsDeletedToListInvitationRecords < ActiveRecord::Migration[5.1]
  def change
    add_column :list_invitation_records, :is_deleted, :boolean
  end
end
