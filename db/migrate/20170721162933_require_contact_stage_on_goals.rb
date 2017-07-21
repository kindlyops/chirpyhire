class RequireContactStageOnGoals < ActiveRecord::Migration[5.1]
  def change
    change_column_null :goals, :contact_stage_id, false
  end
end
