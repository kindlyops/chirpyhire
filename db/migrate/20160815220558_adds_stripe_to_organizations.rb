class AddsStripeToOrganizations < ActiveRecord::Migration[5.0]
  def change
    add_column :organizations, :stripe_customer_id, :string, null: true
    add_column :organizations, :stripe_token, :string, null: true
  end
end
