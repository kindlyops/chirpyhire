class CreateManualMessageReplies < ActiveRecord::Migration[5.1]
  def change
    create_table :manual_message_replies do |t|
      t.belongs_to :manual_message, null: false, index: true, foreign_key: true
      t.belongs_to :message, null: false, index: true, foreign_key: true
      t.timestamps
    end
  end
end
