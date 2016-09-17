# frozen_string_literal: true
class RemovesCategories < ActiveRecord::Migration[5.0]
  def change
    remove_reference :questions, :category
    remove_reference :candidate_features, :category
    drop_table :categories
  end
end
