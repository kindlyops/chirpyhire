class CreateNotUnderstoodIdForSurvey < ActiveRecord::Migration[5.0]
  def change
    add_column :surveys, :not_understood_id, :integer
    add_index :surveys, :not_understood_id
    add_foreign_key :surveys, :templates, column: :not_understood_id
  end
end
