class AddsCustomStageToGoals < ActiveRecord::Migration[5.1]
  def change
    change_column_null :contacts, :contact_stage_id, false
    
    change_table :goals do |t|
      t.belongs_to :contact_stage, index: true, foreign_key: true
    end
  end
end
