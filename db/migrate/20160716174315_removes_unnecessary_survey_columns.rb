class RemovesUnnecessarySurveyColumns < ActiveRecord::Migration[5.0]
  def change
    remove_reference :candidate_features, :persona_feature, index: true, foreign_key: true
    remove_reference :inquiries, :candidate_feature, index: true, foreign_key: true
    remove_reference :candidates, :candidate_persona, index: true, foreign_key: true
  end
end
