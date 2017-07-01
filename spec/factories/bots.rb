FactoryGirl.define do
  factory :bot do
    organization
    name { Faker::Name.name }
    keyword { Faker::Lorem.word }
  end
end
