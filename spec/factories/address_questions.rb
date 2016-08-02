FactoryGirl.define do
  factory :address_question do
    survey
    category
    sequence(:priority)
    type "AddressQuestion"
    text { Faker::Lorem.sentence }
  end
end
