class ListPeopleRecord < ApplicationRecord
  def self.find_ids_of_lists_with_access_for_email(email)
    where(email: email).pluck(:list_id)
  end

  def self.find_all_with_list_id(id)
    where(list_id: id)
  end
end
