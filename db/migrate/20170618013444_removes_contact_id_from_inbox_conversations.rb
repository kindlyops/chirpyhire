class RemovesContactIdFromInboxConversations < ActiveRecord::Migration[5.1]
  def change
    remove_column :inbox_conversations, :contact_id
  end
end
