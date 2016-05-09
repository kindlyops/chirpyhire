class AddsUniquenessConstraints < ActiveRecord::Migration
  def change
    remove_index :accounts, :email
    add_index :accounts, :email, unique: true
    add_index :messages, :sid, unique: true

    remove_index :phones, :organization_id
    add_index :phones, :organization_id, unique: true

    add_index :users, [:organization_id, :phone_number], unique: true
  end
end
