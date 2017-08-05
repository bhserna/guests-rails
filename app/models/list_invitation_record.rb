class ListInvitationRecord < ApplicationRecord
  def self.find_all_by_list_id(list_id)
    where(list_id: list_id).order(:id)
  end

  def self.find_all_groups_by_list_id(list_id)
    order(:id).where(list_id: list_id).where.not(group: nil).pluck(:group).uniq
  end

  def self.counts_by_list_id
    select(:id, :list_id).group(:list_id).count(:id)
  end
end
