class AddsUniquenessCheckToQuestionPriorities < ActiveRecord::Migration[5.0]
  def change
    add_index :questions, [:survey_id, :priority], where: "status=0", unique: true
  end
end
