class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :sid, null: false
      t.date   :date_created
      t.date   :date_updated
      t.date   :date_sent
      t.string :account_sid, null: false
      t.string :messaging_service_sid
      t.string :from, null: false
      t.string :to, null: false
      t.text   :body, null: false
      t.integer :num_media
      t.integer :num_segments
      t.string  :status, null: false
      t.string  :direction, null: false
      t.integer :price
      t.string :price_unit
      t.string :api_version
      t.text   :uri
      t.json   :subresource_uris
      t.timestamps null: false
    end
  end
end
