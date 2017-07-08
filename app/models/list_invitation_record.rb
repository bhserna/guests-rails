class ListInvitationRecord < ApplicationRecord
  def self.find_all_by_list_id(list_id)
    where(list_id: list_id)
  end
end
