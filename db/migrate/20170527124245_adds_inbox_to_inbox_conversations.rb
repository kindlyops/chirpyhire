class AddsInboxToInboxConversations < ActiveRecord::Migration[5.1]
  def change
    add_column :inbox_conversations, :inbox_id, :integer, null: true
    add_index :inbox_conversations, :inbox_id
    add_foreign_key :inbox_conversations, :inboxes
  end
end
