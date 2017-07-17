class AddsTrialEndsAtToSubscriptions < ActiveRecord::Migration[5.1]
  def change
    change_table :subscriptions do |t|
      t.datetime :trial_ends_at
    end
  end
end
