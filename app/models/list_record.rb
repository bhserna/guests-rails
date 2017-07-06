class ListRecord < ApplicationRecord
  def self.save(attrs)
    create(attrs)
  end
end
