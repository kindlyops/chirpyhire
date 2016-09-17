# frozen_string_literal: true
class AddsQuestionsToInquiries < ActiveRecord::Migration[5.0]
  def change
    add_reference :inquiries, :questions, null: true, index: true, foreign_key: true
  end
end
