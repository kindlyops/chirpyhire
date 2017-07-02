FactoryGirl.define do
  factory :question do
    bot
    body { Faker::Lorem.sentence }
    sequence(:rank)
  end
end
