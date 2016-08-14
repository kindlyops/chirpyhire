class CreateSubscriptionPlans < ActiveRecord::Migration[5.0]
  def change
    create_table :subscription_plans do |t|
      t.integer :amount
      t.string :interval
      t.string :stripe_id
      t.string :name

      t.timestamps
    end
  end
end
