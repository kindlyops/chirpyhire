class AddsAccountsToPeople < ActiveRecord::Migration[5.1]
  def change
    add_column :people, :account_id, :integer

    add_index :people, :account_id, unique: true
    add_foreign_key :people, :accounts
  end
end
