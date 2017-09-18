class CreateCharges < ActiveRecord::Migration[5.1]
  def change
    create_table :charges do |t|
      t.belongs_to :invoice, null: false, index: true, foreign_key: true
      t.string :stripe_id, null: false
      t.string :object
      t.integer :amount
      t.integer :amount_refunded
      t.string :application
      t.string :application_fee
      t.string :balance_transaction
      t.boolean :captured
      t.integer :created
      t.string :currency
      t.string :customer
      t.string :description
      t.string :destination
      t.string :dispute
      t.string :failure_code
      t.string :failure_message
      t.jsonb :fraud_details, default: {}
      t.string :invoice, index: true
      t.boolean :livemode
      t.jsonb :metadata, default: {}
      t.string :on_behalf_of
      t.string :order
      t.jsonb :outcome, default: {}
      t.boolean :paid
      t.string :receipt_email
      t.string :receipt_number
      t.boolean :refunded
      t.jsonb :refunds, default: {}
      t.string :review
      t.jsonb :shipping, default: {}
      t.jsonb :source, default: {}
      t.string :source_transfer
      t.string :statement_descriptor
      t.string :status
      t.string :transfer
      t.string :transfer_group
      t.timestamps
    end
    add_index :charges, :stripe_id, unique: true
  end
end
