class Mailer < ActionMailer::Base
  def reset_password_mail(user, reset_uri)
    recipients user.email
    from       "#{APP_CONFIG[:app_title]} <APP_CONFIG[:app_email]>"
    subject    "#{APP_CONFIG[:app_title]} inloggegevens herstellen"
    body       :user => user, :reset_uri => reset_uri
  end
end
