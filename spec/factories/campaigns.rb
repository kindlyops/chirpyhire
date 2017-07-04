FactoryGirl.define do
  factory :campaign do
    organization
    name { Faker::Name.name }
  end
end
