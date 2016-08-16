class RequiresQuantityOnSubscriptions < ActiveRecord::Migration[5.0]
  def change
    change_column :subscriptions, :quantity, :integer, null: false
  end
end
