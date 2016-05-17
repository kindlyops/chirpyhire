FactoryGirl.define do
  factory :account do
    user
    email { Faker::Internet.email }
    password "password"
    password_confirmation "password"
  end
end
