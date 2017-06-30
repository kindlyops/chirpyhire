class CreateBotCampaigns < ActiveRecord::Migration[5.1]
  def change
    create_table :bot_campaigns do |t|
      t.belongs_to :bot, null: false, index: true, foreign_key: true
      t.belongs_to :campaign, null: false, index: true, foreign_key: true
      t.timestamps
    end

    add_index :bot_campaigns, [:bot_id, :campaign_id], unique: true
  end
end
