class RequireTeamsOnTeamRecords < ActiveRecord::Migration[5.1]
  def change
    change_column_null :recruiting_ads, :organization_id, true
    change_column_null :contacts, :organization_id, true
    change_column_null :locations, :team_id, false
    change_column_null :recruiting_ads, :team_id, false
    change_column_null :contacts, :team_id, false
  end
end
