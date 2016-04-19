class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.belongs_to :question, null: false, index: true, foreign_key: true
      t.belongs_to :lead, null: false, index: true, foreign_key: true
      t.belongs_to :message, null: false, foreign_key: true
      t.string :body, null: false
      t.timestamps null: false
    end

    add_index :answers, :message_id, unique: true
  end
end
