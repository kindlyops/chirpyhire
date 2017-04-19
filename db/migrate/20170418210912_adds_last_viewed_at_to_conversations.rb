class AddsLastViewedAtToConversations < ActiveRecord::Migration[5.0]
  def change
    add_column :conversations, :last_viewed_at, :datetime
  end
end
