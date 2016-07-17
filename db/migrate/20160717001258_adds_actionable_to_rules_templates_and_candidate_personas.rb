class AddsActionableToRulesTemplatesAndCandidatePersonas < ActiveRecord::Migration[5.0]
  def change
    add_reference :rules, :actionable, index: true, foreign_key: true
    add_reference :templates, :actionable, index: true, foreign_key: true
    add_reference :candidate_personas, :actionable, index: true, foreign_key: true
  end
end
