class AddsSuperAdminToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :super_admin, :boolean, default: false, null: false
  end
end
