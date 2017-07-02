class UserRecord < ApplicationRecord
  def self.save(attrs)
    create(attrs)
  end
end
