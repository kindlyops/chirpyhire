class RequireConversations < ActiveRecord::Migration[5.1]
  def change
    change_column_null :inbox_conversations, :conversation_id, false
    change_column_null :messages, :conversation_id, false
    remove_column :inbox_conversations, :contact_id
    remove_column :messages, :organization_id
  end
end
