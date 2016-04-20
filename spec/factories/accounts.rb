FactoryGirl.define do
  factory :account do
    user
    email { Faker::Internet.email }
    password "password"
    password_confirmation "password"

    trait :with_organization do
      organization
    end
  end
end
