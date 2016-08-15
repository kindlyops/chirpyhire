class CreateInvoices < ActiveRecord::Migration[5.0]
  def change
    create_table :invoices do |t|
      t.string     :stripe_id, null: false
      t.string     :stripe_subscription_id, null: false
      t.string     :stripe_charge_id
      t.string     :stripe_customer_id
      t.integer    :amount_due
      t.integer    :application_fee
      t.integer    :attempt_count, default: 0
      t.boolean    :attempted
      t.boolean    :closed
      t.string     :currency
      t.timestamp  :date
      t.string     :description
      t.jsonb      :discount
      t.integer    :ending_balance
      t.boolean    :forgiven
      t.jsonb      :lines
      t.boolean    :livemode
      t.timestamp  :next_payment_attempt
      t.boolean    :paid
      t.timestamp  :period_end
      t.timestamp  :period_start
      t.string     :receipt_number
      t.integer    :starting_balance
      t.string     :statement_descriptor
      t.integer    :subtotal
      t.integer    :tax
      t.float      :tax_percent
      t.integer    :total
      t.timestamp  :webhooks_delivered_at
      t.references :subscription, index: true, foreign_key: true, null: false

      t.timestamps
    end

    add_index :invoices, :stripe_id, unique: true
    add_index :invoices, :discount, using: :gin
    add_index :invoices, :lines, using: :gin
  end
end
