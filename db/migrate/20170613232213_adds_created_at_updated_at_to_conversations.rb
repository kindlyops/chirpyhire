class AddsCreatedAtUpdatedAtToConversations < ActiveRecord::Migration[5.1]
  def change
    add_timestamps(:conversations, null: true)
  end
end
