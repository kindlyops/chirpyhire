class RemoveStripe < ActiveRecord::Migration[5.0]
  def change
    drop_table :subscriptions
    drop_table :plans
    remove_column :organizations, :stripe_customer_id
  end
end
