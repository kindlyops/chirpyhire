class CreateZipcodeQuestionOptions < ActiveRecord::Migration[5.0]
  def change
    create_table :zipcode_question_options do |t|
      t.string :text, null: false
      t.references :question, null: false, index: true, foreign_key: true
      t.timestamps
    end

    add_index :zipcode_question_options, [:text, :question_id], unique: true
  end
end
