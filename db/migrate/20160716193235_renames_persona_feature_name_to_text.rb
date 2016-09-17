# frozen_string_literal: true
class RenamesPersonaFeatureNameToText < ActiveRecord::Migration[5.0]
  def change
    rename_column :persona_features, :name, :text
  end
end
