class Listing < ApplicationRecord
  belongs_to  :item
  has_many :notifications, :dependent => :destroy

  after_commit :create_notification, :on => [:create]

  monetize :price_cents

  private

  def create_notification
    user_id = item.user_id
    item_id = item.id

    ::Notification.create(:listing_id => id, :user_id => user_id, :item_id => item_id)
  end
end
