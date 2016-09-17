# frozen_string_literal: true
class RequireQuestionsOnInquiries < ActiveRecord::Migration[5.0]
  def change
    change_column :inquiries, :question_id, :integer, null: false, index: true, foreign_key: true
  end
end
