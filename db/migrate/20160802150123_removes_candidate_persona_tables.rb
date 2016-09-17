# frozen_string_literal: true
class RemovesCandidatePersonaTables < ActiveRecord::Migration[5.0]
  def change
    remove_column :inquiries, :persona_feature_id
    drop_table :persona_features
    drop_table :candidate_personas
  end
end
