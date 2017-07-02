FactoryGirl.define do
  factory :greeting do
    body { Faker::Lorem.sentence }
  end
end
