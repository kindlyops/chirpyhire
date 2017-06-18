class AddsConversationIdToReadReceipts < ActiveRecord::Migration[5.1]
  def change
    add_column :read_receipts, :conversation_id, :integer, null: true, index: true, foreign_key: true
    change_column_null :read_receipts, :inbox_conversation_id, true
  end
end
