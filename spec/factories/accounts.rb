FactoryGirl.define do
  factory :account do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password 'password'
    organization
  end
end
