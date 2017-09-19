class RemoveStripe < ActiveRecord::Migration[5.0]
  def change
    drop_table :subscriptions
    remove_column :organizations, :stripe_customer_id
  end
end
