class Listing < ApplicationRecord
  belongs_to  :item

  monetize :price_cents
end
