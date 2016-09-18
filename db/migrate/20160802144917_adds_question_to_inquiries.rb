class AddsQuestionToInquiries < ActiveRecord::Migration[5.0]
  def change
    remove_reference :inquiries, :questions
    add_reference :inquiries, :question, null: true, index: true, foreign_key: true
  end
end
