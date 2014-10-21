class TransactionMailer < MandrillMailer::TemplateMailer
  default from: "teaser@inhousemedia.com.au"
  
  def welcome_email user
    mandrill_mail template: 'welcome_email',
      subject: "Welcome to Teaser!",
      from_name: "Teaser",
      to: {email: user.email, name: user.name.split(' ').first},
      vars: {
            'USER_NAME' => user.name.split(' ').first
    },
      important: true,
      inline_css: true,
      async: true,
      track_clicks: false
  end
end