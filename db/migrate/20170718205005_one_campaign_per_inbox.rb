class OneCampaignPerInbox < ActiveRecord::Migration[5.1]
  def change
    remove_index :bot_campaigns, :inbox_id
    add_index :bot_campaigns, :inbox_id, unique: true
  end
end
