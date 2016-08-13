class AddsHasAgreedToAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :agreed_to_terms, :boolean, default: false, null: false
  end
end
