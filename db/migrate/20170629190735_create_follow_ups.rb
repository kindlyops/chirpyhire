class CreateFollowUps < ActiveRecord::Migration[5.1]
  def change
    create_table :follow_ups do |t|
      t.belongs_to :question, null: false, index: true, foreign_key: true
      t.integer :next_question_id, null: true, index: true
      t.belongs_to :goal, null: true, index: true, foreign_key: true
      t.string :body, null: false
      t.string :response, null: false
      t.integer :action, null: false, default: 0
      t.timestamps
    end

    add_foreign_key :follow_ups, :questions, column: :next_question_id
  end
end
