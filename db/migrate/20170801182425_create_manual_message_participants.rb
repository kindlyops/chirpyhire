class CreateManualMessageParticipants < ActiveRecord::Migration[5.1]
  def change
    create_table :manual_message_participants do |t|
      t.belongs_to :contact, null: false, index: true, foreign_key: true
      t.belongs_to :manual_message, null: false, index: true, foreign_key: true
      t.belongs_to :message, null: true, index: true, foreign_key: true
      t.integer :reply_id, null: true
      t.timestamps
    end

    add_foreign_key :manual_message_participants, :messages, column: :reply_id
    add_index :manual_message_participants, :reply_id
  end
end
