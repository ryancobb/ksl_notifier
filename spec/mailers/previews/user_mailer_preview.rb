# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def notification_email
    UserMailer.notification_email(User.first)
  end
end
