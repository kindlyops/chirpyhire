class CreateContactsManualMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :contacts_manual_messages do |t|
      t.belongs_to :contact, null: false, index: true, foreign_key: true
      t.belongs_to :manual_message, null: false, index: true, foreign_key: true
      t.belongs_to :message, null: true, index: true, foreign_key: true
      t.integer :reply_id, null: true
      t.timestamps
    end

    add_foreign_key :contacts_manual_messages, :messages, column: :reply_id
    add_index :contacts_manual_messages, :reply_id
  end
end
