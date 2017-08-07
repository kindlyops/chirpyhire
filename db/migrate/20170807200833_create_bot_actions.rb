class CreateBotActions < ActiveRecord::Migration[5.1]
  def change
    create_table :bot_actions do |t|
      t.belongs_to :bot, null: false, index: true, foreign_key: true
      t.string :type, null: false
      t.belongs_to :goal, null: true, index: true, foreign_key: true
      t.belongs_to :question, null: true, index: true, foreign_key: true
      t.timestamps
    end

    change_table :follow_ups do |t|
      t.belongs_to :bot_action, null: true, index: true, foreign_key: true
    end
  end
end
