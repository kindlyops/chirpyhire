# frozen_string_literal: true
FactoryGirl.define do
  factory :document_question do
    survey
    sequence(:label) { |n| "label#{n}" }
    sequence(:priority)
    type 'DocumentQuestion'
    text { Faker::Lorem.sentence }
  end
end
