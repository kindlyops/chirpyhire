# frozen_string_literal: true
class RequireSurveyEngineColumns < ActiveRecord::Migration[5.0]
  def change
    change_column :candidate_features, :category_id, :integer, null: false
    change_column :persona_features, :category_id, :integer, null: false
    change_column :persona_features, :priority, :integer, null: false
    change_column :inquiries, :persona_feature_id, :integer, null: false
    add_index :categories, :name, unique: true
  end
end
