class RelaxFollowUpsIndex < ActiveRecord::Migration[5.1]
  def change
    remove_index :follow_ups, name: "index_follow_ups_on_rank_and_question_id"
  end
end
