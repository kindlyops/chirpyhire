class RequireConversations < ActiveRecord::Migration[5.1]
  def change
    change_column_null :inbox_conversations, :conversation_id, false
    change_column_null :messages, :conversation_id, false
    change_column_null :inbox_conversations, :contact_id, true
    change_column_null :messages, :organization_id, true
  end
end
