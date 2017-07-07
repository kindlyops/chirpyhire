class AddsCanceledAtToSubscriptions < ActiveRecord::Migration[5.1]
  def change
    add_column :subscriptions, :canceled_at, :datetime
  end
end
