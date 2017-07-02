FactoryGirl.define do
  factory :question do
    body { Faker::Lorem.sentence }
  end
end
