# frozen_string_literal: true
FactoryGirl.define do
  factory :referral do
    candidate
    referrer
  end
end
