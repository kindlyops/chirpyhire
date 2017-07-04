FactoryGirl.define do
  factory :tag do
    organization
    name { Faker::Name.name }
  end
end
