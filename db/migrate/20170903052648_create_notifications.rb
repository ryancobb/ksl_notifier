class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.references :listing, foreign_key: true
      t.text :message
      t.boolean :dismissed
      t.boolean :emailed
      t.boolean :sms_sent

      t.timestamps
    end
  end
end
