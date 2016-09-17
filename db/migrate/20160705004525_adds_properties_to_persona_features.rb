# frozen_string_literal: true
class AddsPropertiesToPersonaFeatures < ActiveRecord::Migration[5.0]
  def change
    add_column :persona_features, :properties, :jsonb, null: false, default: '{}'
  end
end
