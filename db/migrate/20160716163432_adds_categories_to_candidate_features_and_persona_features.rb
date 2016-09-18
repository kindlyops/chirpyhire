class AddsCategoriesToCandidateFeaturesAndPersonaFeatures < ActiveRecord::Migration[5.0]
  def change
    add_reference :candidate_features, :category, foreign_key: true
    add_reference :persona_features, :category, foreign_key: true
  end
end
