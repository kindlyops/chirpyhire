FactoryGirl.define do
  factory :yes_no_question do
    survey
    sequence(:label) { |n| "label#{n}" }
    sequence(:priority)
    type 'YesNoQuestion'
    text { Faker::Lorem.sentence }
  end
end
