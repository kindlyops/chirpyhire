class RequireActionable < ActiveRecord::Migration[5.0]
  def change
    change_column :rules, :actionable_id, :integer, null: false, index: true, foreign_key: true
  end
end
