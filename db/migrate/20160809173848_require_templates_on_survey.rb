# frozen_string_literal: true
class RequireTemplatesOnSurvey < ActiveRecord::Migration[5.0]
  def change
    remove_column :surveys, :template_id
    change_column :surveys, :welcome_id, :integer, null: false
    change_column :surveys, :bad_fit_id, :integer, null: false
    change_column :surveys, :thank_you_id, :integer, null: false

    add_index :surveys, :welcome_id
    add_index :surveys, :bad_fit_id
    add_index :surveys, :thank_you_id
    add_foreign_key :surveys, :templates, column: :welcome_id
    add_foreign_key :surveys, :templates, column: :bad_fit_id
    add_foreign_key :surveys, :templates, column: :thank_you_id
  end
end
