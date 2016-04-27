class AddsUniquenessConstraints < ActiveRecord::Migration
  def change
    remove_index :accounts, :email
    add_index :accounts, :email, unique: true

    add_index :accounts, [:organization_id, :user_id], unique: true
    add_index :candidates, [:organization_id, :user_id], unique: true
    add_index :referrers, [:organization_id, :user_id], unique: true
    add_index :messages, :sid, unique: true

    remove_index :phones, :organization_id
    add_index :phones, :organization_id, unique: true

    add_index :users, :phone_number, unique: true
    add_index :subscriptions, [:organization_id, :user_id], where: "deleted_at IS NULL", unique: true
  end
end
