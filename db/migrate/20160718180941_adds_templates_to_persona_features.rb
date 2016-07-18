class AddsTemplatesToPersonaFeatures < ActiveRecord::Migration[5.0]
  def change
    add_reference :persona_features, :template, index: true, foreign_key: true, null: true
  end
end
