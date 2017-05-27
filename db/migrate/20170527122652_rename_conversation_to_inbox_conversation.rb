class RenameConversationToInboxConversation < ActiveRecord::Migration[5.1]
  def change
    rename_table :conversations, :inbox_conversations
    rename_column :read_receipts, :conversation_id, :inbox_conversation_id
  end
end
