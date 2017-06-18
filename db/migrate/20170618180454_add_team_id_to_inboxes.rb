class AddTeamIdToInboxes < ActiveRecord::Migration[5.1]
  def change
    add_column :inboxes, :team_id, :integer, null: true, index: true, foreign_key: true
    change_column_null :inboxes, :account_id, true
  end
end
