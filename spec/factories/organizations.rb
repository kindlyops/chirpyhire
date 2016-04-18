FactoryGirl.define do
  factory :organization do
    name { Faker::Company.name }
    domain { Faker::Internet.domain_name }
  end
end
