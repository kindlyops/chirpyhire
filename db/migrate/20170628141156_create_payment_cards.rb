class CreatePaymentCards < ActiveRecord::Migration[5.1]
  def change
    create_table :payment_cards do |t|
      t.belongs_to :organization, null: false, index: true, foreign_key: true
      t.string :stripe_id, null: false
      t.string :brand, null: false
      t.integer :exp_month, null: false
      t.integer :exp_year, null: false
      t.integer :last4, null: false
      t.timestamps
    end
  end
end
