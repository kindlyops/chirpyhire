class AddRolesToAccountsAndMemberships < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :role, :integer, null: false, default: 0
    add_column :memberships, :role, :integer, null: false, default: 0
  end
end
