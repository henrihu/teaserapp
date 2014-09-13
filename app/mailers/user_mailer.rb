class UserMailer < ActionMailer::Base
  default from: "team@teaser-app.com"

  
  def reset_password_mail user
    @user = user
    @user.update_attribute(:reset_password_sent_at, Time.now)
    mail(:to => @user.email, :subject => "Password Reset Instructions", :from => "Teaser Team")
  end
 
end
