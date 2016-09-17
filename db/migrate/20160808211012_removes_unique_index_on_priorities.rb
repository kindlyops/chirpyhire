# frozen_string_literal: true
class RemovesUniqueIndexOnPriorities < ActiveRecord::Migration[5.0]
  def change
    remove_index :questions, [:survey_id, :priority]
  end
end
