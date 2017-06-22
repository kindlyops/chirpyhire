class MakeTeamRequiredOnInboxes < ActiveRecord::Migration[5.1]
  def change
    change_column_null :inboxes, :team_id, false
  end
end
