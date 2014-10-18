class UserMailer < ActionMailer::Base
  default from: '"Teaser" <javed.hussain@mobiloitte.com>'

  
  def reset_password_mail user
    @user = user
    @user.update_attribute(:reset_password_sent_at, Time.now)
    mail(:to => @user.email, :subject => "Password Reset Instructions")
  end

  def signup_mail user
    @name = user.name.split(' ').first
    mail(:to => user.email, :subject => 'Welcome to Teaser')
  end  
 
end
