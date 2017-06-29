class CreateGoals < ActiveRecord::Migration[5.1]
  def change
    create_table :goals do |t|
      t.belongs_to :bot, null: false, index: true, foreign_key: true
      t.text :body, null: false
      t.timestamps
    end
  end
end
