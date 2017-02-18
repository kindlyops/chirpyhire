FactoryGirl.define do
  factory :account do
    email { Faker::Internet.email }
    password 'password'
  end
end
