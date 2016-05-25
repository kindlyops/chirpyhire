FactoryGirl.define do
  factory :message do
    sid { Faker::Number.number(10) }
    body { Faker::Lorem.word }
    user
  end
end
