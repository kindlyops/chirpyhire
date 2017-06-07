class AddsUniquenessConstraintToInboxConversations < ActiveRecord::Migration[5.1]
  def change
    add_index :inbox_conversations, [:conversation_id, :inbox_id], unique: true
  end
end
