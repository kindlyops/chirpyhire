# frozen_string_literal: true
FactoryGirl.define do
  factory :subscription do
    plan
    state 'trialing'
    trial_message_limit 500
    organization
  end
end
