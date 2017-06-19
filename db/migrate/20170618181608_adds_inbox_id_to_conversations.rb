class AddsInboxIdToConversations < ActiveRecord::Migration[5.1]
  def change
    add_column :conversations, :inbox_id, :bigint, null: true, index: true, foreign_key: true
  end
end
