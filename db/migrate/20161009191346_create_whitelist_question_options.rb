class CreateWhitelistQuestionOptions < ActiveRecord::Migration[5.0]
  def change
    create_table :whitelist_question_options do |t|
      t.string :text, null: false
      t.references :question, null: false, index: true, foreign_key: true
      t.timestamps
    end

    add_index :whitelist_question_options, [:text, :question_id], unique: true
  end
end
