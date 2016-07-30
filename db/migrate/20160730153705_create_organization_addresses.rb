class CreateOrganizationAddresses < ActiveRecord::Migration[5.0]
  def change
    create_table :organization_addresses do |t|
      t.float :latitude
      t.float :longitude
      t.string :full_street_address
      t.string :city
      t.string :state
      t.string :state_code
      t.integer :postal_code
      t.string :country
      t.string :country_code
      t.references :organization, null: false, index: true, foreign_key: true
      t.timestamps
    end
  end
end
