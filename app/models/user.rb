class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation, :admin
  
  has_secure_password
  
  validates :email, uniqueness: true
end
