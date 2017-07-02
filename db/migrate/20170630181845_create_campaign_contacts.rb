class CreateCampaignContacts < ActiveRecord::Migration[5.1]
  def change
    create_table :campaign_contacts do |t|
      t.belongs_to :campaign, null: false, index: true, foreign_key: true
      t.belongs_to :contact, null: false, index: true, foreign_key: true
      t.integer :state, null: false, default: 0
      t.timestamps
    end

    add_index :campaign_contacts, [:campaign_id, :contact_id], unique: true
  end
end
