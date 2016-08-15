class CreateSubscriptions < ActiveRecord::Migration[5.0]
  def change
    create_table :subscriptions do |t|
      t.string     :stripe_id
      t.string     :stripe_customer_id
      t.float      :application_fee_percent
      t.boolean    :cancel_at_period_end
      t.timestamp  :canceled_at
      t.timestamp  :stripe_created_at
      t.timestamp  :current_period_end
      t.timestamp  :current_period_start
      t.timestamp  :ended_at
      t.integer    :quantity
      t.timestamp  :start
      t.string     :status
      t.float      :tax_percent
      t.timestamp  :trial_end
      t.timestamp  :trial_start
      t.references :plan, index: true, foreign_key: true, null: false
      t.references :organization, index: true, foreign_key: true, null: false
      t.integer    :state, null: false, default: 0

      t.timestamps
    end

    add_index :subscriptions, :stripe_id, unique: true
  end
end
