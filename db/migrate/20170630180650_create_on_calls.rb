class CreateOnCalls < ActiveRecord::Migration[5.1]
  def change
    create_table :on_calls do |t|
      t.belongs_to :bot, null: false, index: true, foreign_key: true
      t.belongs_to :inbox, null: false, index: true, foreign_key: true
      t.timestamps
    end

    add_index :on_calls, [:bot_id, :inbox_id], unique: true
  end
end
