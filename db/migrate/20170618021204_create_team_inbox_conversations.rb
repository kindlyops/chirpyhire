class CreateTeamInboxConversations < ActiveRecord::Migration[5.1]
  def change
    create_table :team_inbox_conversations do |t|
      t.belongs_to :team_inbox, null: false, index: true, foreign_key: true
      t.belongs_to :conversation, null: false, index: true, foreign_key: true
      t.timestamps
    end
  end
end
