class MakeStageColumnsNotNullable < ActiveRecord::Migration[5.0]
  def change
    change_column_null :stages, :organization_id, false
    change_column_null :stages, :name, false
    change_column_null :stages, :order, false
  end
end
