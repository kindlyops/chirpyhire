class CreateSearchQuestionMessages < ActiveRecord::Migration
  def change
    create_table :search_question_messages do |t|
      t.belongs_to :message, null: false, index: true, foreign_key: true
      t.belongs_to :search_lead, null: false, index: true, foreign_key: true
      t.belongs_to :search_question, null: false, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
