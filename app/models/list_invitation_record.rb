class ListInvitationRecord < ApplicationRecord
  default_scope { order(:id) }

  def self.find_all_by_list_id(list_id)
    where(list_id: list_id)
  end

  def self.find_all_groups
    where.not(group: nil).pluck(:group).uniq
  end
end
