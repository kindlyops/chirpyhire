FactoryGirl.define do
  factory :document_question do
    survey
    category
    sequence(:priority)
    type "DocumentQuestion"
    text { Faker::Lorem.sentence }
  end
end
