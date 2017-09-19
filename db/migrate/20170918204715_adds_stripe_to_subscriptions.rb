class AddsStripeToSubscriptions < ActiveRecord::Migration[5.1]
  def change
    rename_column :organizations, :stripe_customer_id, :stripe_id
    rename_column :subscriptions, :canceled_at, :internal_canceled_at
    rename_column :subscriptions, :status, :internal_status

    change_table :subscriptions do |t|
      t.string :stripe_id
      t.string :object
      t.float :application_fee_percent
      t.string :billing
      t.boolean :cancel_at_period_end
      t.integer :canceled_at
      t.integer :created
      t.integer :current_period_end
      t.integer :current_period_start
      t.string :customer
      t.jsonb :discount, default: {}
      t.integer :ended_at
      t.jsonb :items, default: {}
      t.boolean :livemode
      t.jsonb :metadata, default: {}
      t.jsonb :plan, default: {}
      t.integer :quantity
      t.integer :start
      t.string :status
      t.float :tax_percent
      t.integer :trial_end
      t.integer :trial_start
    end

    add_index :subscriptions, :stripe_id, unique: true
    add_index :subscriptions, :customer
  end
end
