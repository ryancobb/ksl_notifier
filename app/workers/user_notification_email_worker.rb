class UserNotificationEmailWorker
  include Sidekiq::Worker

  def perform
    mg_client = Mailgun::Client.new(ENV["MAILGUN_API_KEY"])

    user_ids = Notification.distinct(:user_id).undelivered_emails.pluck(:user_id)
    users = User.where(:id => user_ids)

    users.find_each do |user|
      undelivered_notifications = user.notifications.undelivered_emails
      next unless undelivered_notifications.present?

      message = build_message(user, undelivered_notifications)
      mg_client.send_message("sandboxff64203728a14ec5a28d2a15f3f08e63.mailgun.org", message)
      undelivered_notifications.update_all(:emailed => true)
    end
  end

  private

  def build_message(user, undelivered_notifications)
    listings = ::Listing.where(:id => undelivered_notifications.map(&:listing_id)).select(:title, :link, :item_id)
    listings_by_item = listings.group_by { |listing| listing.item_id }

    {
      :from => "KSL Notifier <postmaster@sandboxff64203728a14ec5a28d2a15f3f08e63.mailgun.org>",
      :to => user.email,
      :subject => "KSL Notifier has found new listings!",
      :text => build_message_text(listings_by_item),
    }
  end

  def build_message_text(listings_by_item)
    message = "KSL Notifier found new listings! \n\n"

    listings_by_item.each do |item, listings|
      item = ::Item.find(item)
      message << item.name + "\n"

      listings.each do |listing|
        message << listing.title + " - " + listing.link + "\n"
      end
    end

    message
  end
end
