class AddsNameToAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :name, :string
  end
end
