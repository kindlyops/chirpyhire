class AddsCampaignsToMessages < ActiveRecord::Migration[5.1]
  def change
    change_table :messages do |t|
      t.belongs_to :campaign, null: true, index: true, foreign_key: true
    end
  end
end
