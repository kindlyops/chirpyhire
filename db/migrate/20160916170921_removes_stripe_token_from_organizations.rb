class RemovesStripeTokenFromOrganizations < ActiveRecord::Migration[5.0]
  def change
    remove_column :organizations, :stripe_token
  end
end
