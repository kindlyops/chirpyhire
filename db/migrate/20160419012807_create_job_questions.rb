class CreateJobQuestions < ActiveRecord::Migration
  def change
    create_table :job_questions do |t|
      t.belongs_to :job, null: false, index: true, foreign_key: true
      t.belongs_to :question, null: false, index: true, foreign_key: true
      t.integer :next_question_id, index: true, foreign_key: true
      t.integer :previous_question_id, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
