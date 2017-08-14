class AddDeletedAtToBotActions < ActiveRecord::Migration[5.1]
  def change
    add_column :bot_actions, :deleted_at, :datetime
    add_index :bot_actions, :deleted_at
  end
end
