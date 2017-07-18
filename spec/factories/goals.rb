FactoryGirl.define do
  factory :goal do
    body { Faker::Lorem.sentence }
  end
end
