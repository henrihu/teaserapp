class User < ActiveRecord::Base
	has_secure_password
  
	has_many :favorites, :dependent => :destroy
	has_many :histories, :dependent => :destroy
	validates :name, presence: true, length: {  in: 3..25 }
	validates :age, presence: true
	validates :gender, presence: true
  validates :email, presence: true, uniqueness: true, 
						format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i , 
						message: "Please enter valid email address."}
	has_many :my_histories, :through => :histories, :source => :history
	has_many :my_favorites, :through => :favorites, :source => :favorite						
  has_many :users_videos, :dependent => :destroy
  has_many :videos, through: :users_videos
  after_create :welcome_mail
  
  def send_token
    self.update_attribute(:reset_password_token, SecureRandom.urlsafe_base64+Time.now.zone)
    UserMailer.reset_password_mail(self).deliver
  end 

  def welcome_mail
    TransactionMailer.welcome_email(self).deliver
  end 

end
