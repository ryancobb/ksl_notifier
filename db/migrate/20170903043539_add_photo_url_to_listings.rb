class AddPhotoUrlToListings < ActiveRecord::Migration[5.0]
  def change
    add_column :listings, :photo_url, :text
  end
end
