FactoryGirl.define do
  factory :greeting do
    bot
    body { Faker::Lorem.sentence }
  end
end
