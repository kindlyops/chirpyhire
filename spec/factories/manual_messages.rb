FactoryGirl.define do
  factory :manual_message do
    body { Faker::Lorem.sentence }
    title { Faker::Lorem.sentence }
    account
    audience { {} }
  end
end
