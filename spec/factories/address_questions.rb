# frozen_string_literal: true
FactoryGirl.define do
  factory :address_question do
    survey
    sequence(:label) { |n| "label#{n}" }
    sequence(:priority)
    type 'AddressQuestion'
    text { Faker::Lorem.sentence }
  end
end
