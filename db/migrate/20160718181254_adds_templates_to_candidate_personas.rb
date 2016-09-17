# frozen_string_literal: true
class AddsTemplatesToCandidatePersonas < ActiveRecord::Migration[5.0]
  def change
    add_reference :candidate_personas, :template, index: true, foreign_key: true, null: true
  end
end
