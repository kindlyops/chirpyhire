class UpdatesRankQuestionIndex < ActiveRecord::Migration[5.1]
  def change
    remove_index :questions, [:rank, :bot_id]
    add_index :questions, [:rank, :bot_id], where: "deleted_at IS NULL", unique: true
  end
end
