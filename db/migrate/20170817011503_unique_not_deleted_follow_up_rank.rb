class UniqueNotDeletedFollowUpRank < ActiveRecord::Migration[5.1]
  def change
    remove_index :follow_ups, name: "index_follow_ups_on_question_id_and_rank"
    add_index :follow_ups, [:rank, :question_id], where: "deleted_at IS NULL", unique: true
  end
end
