class MakeNotUnderstoodIdNotNullable < ActiveRecord::Migration[5.0]
  def change
    change_column_null(:surveys, :not_understood_id, false)
  end
end
