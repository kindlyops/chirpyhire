class OptionalConversation < ActiveRecord::Migration[5.1]
  def change
    change_column_null :messages, :organization_id, false
    change_column_null :messages, :conversation_id, true
  end
end
