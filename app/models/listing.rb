class Listing < ApplicationRecord
  belongs_to  :item

  after_commit :create_notification_for_create, :on => [:create]
  after_commit :create_notification_for_update, :on => [:update]

  monetize :price_cents

  private

  def create_notification_for_create
    ::Notification.create(:listing_id => id, :user_id => item.user_id, :message => "A new listing has been created!")
  end

  def create_notification_for_update
    ::Notification.create(:listing_id => id, :user_id => item.user_id, :message => "A listing has been updated!")
  end
end
