class UserNotificationEmailWorker
  include Sidekiq::Worker

  def perform
    user_ids = Notification.distinct(:user_id).undelivered_emails.pluck(:user_id)
    users = User.where(:id => user_ids)

    users.find_each do |user|
      ::UserMailer.notification_email(user).deliver_now
    end
  end
end
