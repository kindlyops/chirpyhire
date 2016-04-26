class AddScreeningUniquenessConstraints < ActiveRecord::Migration
  def change
    add_index :search_questions, [:search_id, :question_id], unique: true
    add_index :search_candidates, [:search_id, :candidate_id], unique: true
    add_index :inquiries, [:candidate_id, :question_id], unique: true, name: "index_by_search_candidate_and_search_question"
  end
end
