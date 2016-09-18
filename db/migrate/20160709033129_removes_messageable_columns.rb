class RemovesMessageableColumns < ActiveRecord::Migration[5.0]
  def up
    remove_column :messages, :messageable_type, :string
    remove_column :messages, :messageable_id, :integer
    change_column :messages, :user_id, :integer, null: false
    add_foreign_key :messages, :users
  end

  def down
    add_column :messages, :messageable_type, :string
    add_column :messages, :messageable_id, :integer
    change_column :messages, :user_id, :integer, null: true
    remove_foreign_key :messages, :users
  end
end
