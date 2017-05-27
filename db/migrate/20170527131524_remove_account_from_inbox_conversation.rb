class RemoveAccountFromInboxConversation < ActiveRecord::Migration[5.1]
  def change
    remove_column :inbox_conversations, :account_id
  end
end
