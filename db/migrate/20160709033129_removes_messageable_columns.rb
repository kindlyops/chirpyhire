class RemovesMessageableColumns < ActiveRecord::Migration[5.0]
  def change
    remove_column :messages, :messageable_type
    remove_column :messages, :messageable_id
    change_column :messages, :user_id, :integer, null: false
  end
end
