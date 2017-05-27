class AddsUnreadCountToInboxes < ActiveRecord::Migration[5.1]
  def self.up
    add_column :inboxes, :unread_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :inboxes, :unread_count, :integer
  end
end
