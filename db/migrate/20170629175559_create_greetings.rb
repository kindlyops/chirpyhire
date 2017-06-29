class CreateGreetings < ActiveRecord::Migration[5.1]
  def change
    create_table :greetings do |t|
      t.belongs_to :bot, null: false, index: true, foreign_key: true
      t.text :body, null: false
      t.timestamps
    end
  end
end
