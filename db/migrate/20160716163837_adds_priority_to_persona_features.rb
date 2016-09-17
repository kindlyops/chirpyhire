# frozen_string_literal: true
class AddsPriorityToPersonaFeatures < ActiveRecord::Migration[5.0]
  def change
    add_column :persona_features, :priority, :integer
    add_index :persona_features, [:candidate_persona_id, :priority], unique: true
  end
end
