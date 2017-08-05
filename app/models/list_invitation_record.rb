class ListInvitationRecord < ApplicationRecord
  default_scope { order(:id) }

  def self.find_all_by_list_id(list_id)
    where(list_id: list_id)
  end

  def self.find_all_groups_by_list_id(list_id)
    where(list_id: list_id).where.not(group: nil).pluck(:group).uniq
  end

  def self.counts_by_list_id
    group(:list_id).distinct.count(:id)
  end
end
