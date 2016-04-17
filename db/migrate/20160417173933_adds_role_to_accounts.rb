class AddsRoleToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :role, :integer, default: 0, null: false
  end
end
