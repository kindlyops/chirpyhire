class RequireCampaignsBotsColumns < ActiveRecord::Migration[5.1]
  def change
    change_column_null :bots, :last_edited_by_id, false
    change_column_null :campaigns, :last_edited_by_id, false
    change_column_null :bots, :account_id, false
    change_column_null :campaigns, :account_id, false
    change_column_null :campaigns, :last_edited_at, false
    change_column_null :bots, :last_edited_at, false
  end
end
