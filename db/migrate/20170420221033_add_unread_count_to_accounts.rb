class AddUnreadCountToAccounts < ActiveRecord::Migration

  def self.up

    add_column :accounts, :unread_count, :integer, :null => false, :default => 0

  end

  def self.down

    remove_column :accounts, :unread_count

  end

end
