class CreateZipcodeTable < ActiveRecord::Migration[5.0]
  def change
    create_table :zipcodes do |t|
      t.string :zipcode, null: false
      t.string :zipcode_type
      t.string :default_city
      t.string :county_fips
      t.string :county_name
      t.string :state_abbreviation
      t.string :state
      t.float :latitude
      t.float :longitude
      t.string :precision
    end

    change_table :people do |t|
      t.belongs_to :zipcode, null: true, index: true, foreign_key: true
    end
  end
end
