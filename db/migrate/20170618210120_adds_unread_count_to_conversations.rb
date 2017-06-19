class AddsUnreadCountToConversations < ActiveRecord::Migration[5.1]
  def change
    add_column :conversations, :unread_count, :integer, null: false, default: 0
  end
end
