class AddsPropertiesToPersonaFeatures < ActiveRecord::Migration
  def change
    add_column :persona_features, :properties, :jsonb, null: false, default: '{}'
  end
end
