# frozen_string_literal: true
FactoryGirl.define do
  factory :actionable do
    type { Actionable::TYPES.sample }
  end
end
