# frozen_string_literal: true
class CreateLocations < ActiveRecord::Migration[5.0]
  def change
    create_table :locations do |t|
      t.float :latitude, null: false
      t.float :longitude, null: false
      t.string :full_street_address, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.string :state_code
      t.string :postal_code, null: false
      t.string :country, null: false
      t.string :country_code
      t.references :organization, null: false, index: true, foreign_key: true
      t.timestamps
    end
  end
end
