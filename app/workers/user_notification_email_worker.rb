class UserNotificationEmailWorker
  include Sidekiq::Worker

  def perform
    User.find_each do |user|
      NotificationsMailer.user_notifications_email(user)
    end
  end
end
