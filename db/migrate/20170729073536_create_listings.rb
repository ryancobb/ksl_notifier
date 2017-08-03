class CreateListings < ActiveRecord::Migration[5.0]
  def change
    create_table :listings do |t|
      t.text :title
      t.text :short_description
      t.text :full_description
      t.text :location
      t.text :link
      t.decimal :price, :precision => 8, :scale => 2
      t.date :posted_on

      t.timestamps
    end
  end
end
