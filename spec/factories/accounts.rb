FactoryGirl.define do
  factory :account do
    association :person, :with_name
    email { Faker::Internet.email }
    password 'password'
    organization
  end
end
