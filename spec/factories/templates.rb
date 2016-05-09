FactoryGirl.define do
  factory :template do
    organization
    name { Faker::Lorem.word }
    body { Faker::Lorem.paragraph }
  end
end
