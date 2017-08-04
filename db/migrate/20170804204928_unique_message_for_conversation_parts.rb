class UniqueMessageForConversationParts < ActiveRecord::Migration[5.1]
  def change
    remove_index :conversation_parts, :message_id
    add_index :conversation_parts, :message_id, unique: true
  end
end
