class RequireInboxIdOnConversations < ActiveRecord::Migration[5.1]
  def change
    change_column_null :conversations, :inbox_id, false
  end
end
