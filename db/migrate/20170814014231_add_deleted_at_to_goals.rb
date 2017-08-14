class AddDeletedAtToGoals < ActiveRecord::Migration[5.1]
  def change
    add_column :goals, :deleted_at, :datetime
    add_index :goals, :deleted_at

    remove_index :goals, name: "index_goals_on_bot_id_and_rank"
    add_index :goals, [:rank, :bot_id], where: "deleted_at IS NULL", unique: true
  end
end
