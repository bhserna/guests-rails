class ListRecord < ApplicationRecord
  def self.save(attrs)
    create(attrs)
  end

  def self.update_list(list_id, attrs)
    find_by(list_id: list_id).update(attrs)
  end

  def self.find_all_by_user_id(user_id)
    where(user_id: user_id)
  end

  def self.find_all_by_list_ids(list_ids)
    where(list_id: list_ids)
  end
end
