class UserMailer < ApplicationMailer

  def notification_email(user)
    @undelivered_notifications = user.notifications.undelivered_emails
    return unless @undelivered_notifications.present?

    @listings_by_item = get_listings_by_item

    mail(:to => user.email, :subject => "KSL Notify found new listings!")

    # @undelivered_notifications.update_all(:emailed => true)
  end

  private

  def get_listings_by_item
    listings = ::Listing.includes(:item).where(:id => @undelivered_notifications.map(&:listing_id))
    listings.group_by { |listing| listing.item }
  end
end
