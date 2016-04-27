class AddScreeningUniquenessConstraints < ActiveRecord::Migration
  def change
    add_index :job_questions, [:job_id, :question_id], unique: true
    add_index :job_candidates, [:job_id, :candidate_id], unique: true
    add_index :inquiries, [:candidate_id, :question_id], unique: true, name: "index_by_job_candidate_and_job_question"
  end
end
