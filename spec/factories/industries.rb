FactoryGirl.define do
  factory :industry do
    name { Faker::Company.name }
  end
end
