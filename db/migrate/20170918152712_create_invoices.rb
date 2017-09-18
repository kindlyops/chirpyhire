class CreateInvoices < ActiveRecord::Migration[5.1]
  def change
    create_table :invoices do |t|
      t.belongs_to :subscription, null: false, index: true, foreign_key: true
      t.string :stripe_id, null: false
      t.string :object
      t.integer :amount_due
      t.integer :application_fee
      t.integer :attempt_count
      t.boolean :attempted
      t.string :billing
      t.string :charge
      t.boolean :closed
      t.string :currency
      t.string :customer
      t.integer :date
      t.string :description
      t.jsonb :discount
      t.integer :due_date
      t.integer :ending_balance
      t.boolean :forgiven
      t.text :lines, array: true, default: []
      t.boolean :livemode
      t.jsonb :metadata
      t.integer :next_payment_attempt
      t.string :number
      t.boolean :paid
      t.integer :period_end
      t.integer :period_start
      t.string :receipt_number
      t.integer :starting_balance
      t.string :statement_descriptor
      t.string :subscription
      t.integer :subscription_proration_date
      t.integer :subtotal
      t.integer :tax
      t.float :tax_percent
      t.integer :total
      t.integer :webhooks_delivered_at
      t.timestamps
    end
  end
end
