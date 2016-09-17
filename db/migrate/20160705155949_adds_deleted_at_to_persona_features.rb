# frozen_string_literal: true
class AddsDeletedAtToPersonaFeatures < ActiveRecord::Migration[5.0]
  def change
    add_column :persona_features, :deleted_at, :datetime
    add_index :persona_features, :deleted_at
  end
end
