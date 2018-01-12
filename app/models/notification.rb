class Notification < ApplicationRecord
  belongs_to :item
  belongs_to :listing
  belongs_to :user

  scope :undelivered_emails, -> { where(:emailed => [false, nil]) }
end
