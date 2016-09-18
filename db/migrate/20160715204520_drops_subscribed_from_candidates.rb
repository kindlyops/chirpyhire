class DropsSubscribedFromCandidates < ActiveRecord::Migration[5.0]
  def change
    remove_column :candidates, :subscribed, :boolean
  end
end
