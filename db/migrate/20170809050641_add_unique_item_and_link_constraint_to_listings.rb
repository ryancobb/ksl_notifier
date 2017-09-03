class AddUniqueItemAndLinkConstraintToListings < ActiveRecord::Migration[5.0]
  def change
    add_index :listings, [:link, :item_id], unique: true
  end
end
