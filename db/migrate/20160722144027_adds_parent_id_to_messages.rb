class AddsParentIdToMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :parent_id, :integer
  end
end
