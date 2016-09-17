# frozen_string_literal: true
class AddsTrialMessageLimitToSubscriptions < ActiveRecord::Migration[5.0]
  def change
    add_column :subscriptions, :trial_message_limit, :integer, null: false, default: 0
  end
end
