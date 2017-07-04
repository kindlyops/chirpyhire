class CreateCampaigns < ActiveRecord::Migration[5.1]
  def change
    create_table :campaigns do |t|
      t.belongs_to :organization, null: false, index: true, foreign_key: true
      t.string :name, null: false, index: true, foreign_key: true
      t.timestamps
    end

    add_index :campaigns, [:organization_id, :name], unique: true
  end
end
