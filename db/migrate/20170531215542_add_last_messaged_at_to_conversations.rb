class AddLastMessagedAtToConversations < ActiveRecord::Migration[5.1]
  def change
    add_column :conversations, :last_message_created_at, :datetime
  end
end
