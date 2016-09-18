class AddsSuperAdminToAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :super_admin, :boolean, default: false, null: false
  end
end
