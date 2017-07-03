class CreateQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :questions do |t|
      t.belongs_to :bot, null: false, index: true, foreign_key: true
      t.text :body, null: false
      t.boolean :active, null: false, default: true
      t.string :type, null: false, default: 'ChoiceQuestion'
      t.integer :rank, null: false
      t.timestamps
    end

    add_index :questions, [:rank, :bot_id], unique: true
  end
end
