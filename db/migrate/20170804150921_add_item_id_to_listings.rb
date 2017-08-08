class AddItemIdToListings < ActiveRecord::Migration[5.0]
  def change
    add_column :listings, :item_id, :integer
  end
end
