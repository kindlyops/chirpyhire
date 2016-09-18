class AddsUniquenessConstraints < ActiveRecord::Migration[5.0]
  def change
    remove_index :accounts, :email
    add_index :accounts, :email, unique: true

    add_index :users, [:organization_id, :phone_number], unique: true
  end
end
