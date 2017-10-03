class RemoveUniqueRankFromQuestions < ActiveRecord::Migration[5.1]
  def change
    remove_index :questions, name: 'index_questions_on_rank_and_bot_id'
  end
end
