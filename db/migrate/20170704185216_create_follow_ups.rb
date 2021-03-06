class CreateFollowUps < ActiveRecord::Migration[5.1]
  def change
    create_table :follow_ups do |t|
      t.belongs_to :question, null: false, index: true, foreign_key: true
      t.string :body, null: false
      t.integer :action, null: false, default: 0
      t.string :type, null: false, default: 'ChoiceFollowUp'
      t.integer :next_question_id, null: true, index: true
      t.belongs_to :goal, null: true, index: true, foreign_key: true
      t.integer :rank, null: false
      t.string :response
      t.timestamps
    end

    add_index :follow_ups, [:question_id, :rank], unique: true
    add_foreign_key :follow_ups, :questions, column: :next_question_id
  end
end
