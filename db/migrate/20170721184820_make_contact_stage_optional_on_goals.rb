class MakeContactStageOptionalOnGoals < ActiveRecord::Migration[5.1]
  def change
    change_column_null :goals, :contact_stage_id, true
  end
end
