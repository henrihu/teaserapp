class User < ActiveRecord::Base
	has_secure_password
	has_many :favorites, :dependent => :destroy
	validates :name, presence: true, length: {  in: 3..25 }
	validates :age, presence: true
	validates :gender, presence: true
  validates :email, presence: true, uniqueness: true, 
						format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i , 
						message: "Please enter valid email address."}
end
