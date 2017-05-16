class RenameConversationsToContactConversations < ActiveRecord::Migration[5.0]
  def change
    rename_table :conversations, :contact_conversations
  end
end
