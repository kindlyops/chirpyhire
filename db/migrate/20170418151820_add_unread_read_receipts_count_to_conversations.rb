class AddUnreadReadReceiptsCountToConversations < ActiveRecord::Migration[5.0]

  def self.up
    add_column :conversations, :unread_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :conversations, :unread_count, :integer
  end
end
