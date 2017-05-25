class AddsBioToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :bio, :text
  end
end
