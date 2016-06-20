class CreateIdealProfiles < ActiveRecord::Migration
  def change
    create_table :ideal_profiles do |t|
      t.belongs_to :organization, null: false, foreign_key: true
      t.timestamps null: false
    end

    add_reference :candidates, :ideal_profile, null: false, index: true, foreign_key: true
    add_index :ideal_profiles, :organization_id, unique: true
  end
end
