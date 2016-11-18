class AddUniqueIndexToQuestionsOnSurveyIdAndPriority < ActiveRecord::Migration[5.0]
  def change
    add_index :questions, [:survey_id, :priority], unique: true
  end
end
