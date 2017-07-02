module Encryptor
  def self.encrypt(password)
    BCrypt::Password.create(password)
  end

  def self.password?(hash, password)
    BCrypt::Password.new(hash) == password
  end
end
