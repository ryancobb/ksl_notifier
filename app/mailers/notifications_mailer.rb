class NotificationsMailer < ApplicationMailer

  def user_notifications_email(user)
    @user = user
    @noticications = @user.notifications.where(:emailed => false)

    if @notifications.present?
      mail(:to => @user.email, :subject => "You have #{@notifications.count} new listings!")
      @notifications.update_all(:emailed => true)
    end
  end
  
end
