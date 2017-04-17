class DropNameAvatarFromAccounts < ActiveRecord::Migration[5.0]
  def change
    remove_attachment :accounts, :avatar
    remove_column :accounts, :name
  end
end
