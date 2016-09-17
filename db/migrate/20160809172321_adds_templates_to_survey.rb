# frozen_string_literal: true
class AddsTemplatesToSurvey < ActiveRecord::Migration[5.0]
  def change
    add_column :surveys, :welcome_id, :integer, null: true, index: true, foreign_key: true
    add_column :surveys, :thank_you_id, :integer, null: true, index: true, foreign_key: true
    add_column :surveys, :bad_fit_id, :integer, null: true, index: true, foreign_key: true
  end
end
