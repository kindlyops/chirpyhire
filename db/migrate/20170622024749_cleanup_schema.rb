class CleanupSchema < ActiveRecord::Migration[5.1]
  def change
    remove_column :read_receipts, :inbox_conversation_id
    change_column_null :read_receipts, :conversation_id, false
    drop_table :inbox_conversations
    remove_column :inboxes, :account_id
  end
end
