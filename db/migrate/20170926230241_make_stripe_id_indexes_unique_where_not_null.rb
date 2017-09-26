class MakeStripeIdIndexesUniqueWhereNotNull < ActiveRecord::Migration[5.1]
  def change
    remove_index :invoices, :stripe_id
    add_index :invoices, :stripe_id, unique: true, where: 'stripe_id IS NOT NULL'
    remove_index :plans, :stripe_id
    add_index :plans, :stripe_id, unique: true, where: 'stripe_id IS NOT NULL'
    remove_index :subscriptions, :stripe_id
    add_index :subscriptions, :stripe_id, unique: true, where: 'stripe_id IS NOT NULL'


    add_index :organizations, :stripe_id, unique: true, where: 'stripe_id IS NOT NULL'
    add_index :payment_cards, :stripe_id, unique: true, where: 'stripe_id IS NOT NULL'

  end
end
