FactoryGirl.define do
  factory :template do
    name { Faker::Lorem.word }
    body { Faker::Lorem.paragraph }
  end
end
