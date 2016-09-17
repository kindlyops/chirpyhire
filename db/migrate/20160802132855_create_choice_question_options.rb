# frozen_string_literal: true
class CreateChoiceQuestionOptions < ActiveRecord::Migration[5.0]
  def change
    create_table :choice_question_options do |t|
      t.string :letter, null: false
      t.string :text, null: false
      t.references :question, null: false, index: true, foreign_key: true
      t.timestamps
    end

    add_index :choice_question_options, [:letter, :question_id], unique: true
    add_index :choice_question_options, [:text, :question_id], unique: true
  end
end
