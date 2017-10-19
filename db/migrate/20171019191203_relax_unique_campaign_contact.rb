class RelaxUniqueCampaignContact < ActiveRecord::Migration[5.1]
  def change
    remove_index :campaign_contacts, [:campaign_id, :contact_id]
    add_index :campaign_contacts, [:campaign_id, :contact_id], where: 'state != 2', unique: true
  end
end
