class RemoveUnreadCountFromAccounts < ActiveRecord::Migration[5.1]
  def change
    remove_column :accounts, :unread_count
  end
end
