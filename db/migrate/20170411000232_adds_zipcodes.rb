class AddsZipcodes < ActiveRecord::Migration[5.0]
  def change
    create_table :zipcodes do |t|
      t.string :zipcode, null: false
      t.string :zipcode_type, null: false
      t.string :default_city, null: false
      t.string :county_fips, null: false
      t.string :county_name, null: false
      t.string :state_abbreviation, null: false
      t.string :state, null: false
      t.float  :latitude, null: false
      t.float  :longitude, null: false
      t.string :precision, null: false
    end

    add_index :zipcodes, :zipcode, unique: true

    change_table :people do |t|
      t.belongs_to :zipcode, null: true, index: true, foreign_key: true
    end
  end
end
