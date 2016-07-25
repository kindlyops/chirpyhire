class AddsChildToMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :child_id, :integer
    add_index :messages, :child_id, unique: true
  end
end
