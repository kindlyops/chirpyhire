class RequiredTimestampsConversations < ActiveRecord::Migration[5.1]
  def change
    change_column_null :conversations, :created_at, false
    change_column_null :conversations, :updated_at, false
  end
end
