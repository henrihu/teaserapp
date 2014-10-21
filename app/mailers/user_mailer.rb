class UserMailer < ActionMailer::Base
  default from: '"Teaser" <teaser@inhousemedia.com.au>'

  
  def reset_password_mail user
    @user = user
    @user.update_attribute(:reset_password_sent_at, Time.now)
    mail(:to => @user.email, :subject => "Password Reset Instructions")
  end

end
