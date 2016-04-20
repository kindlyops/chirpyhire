FactoryGirl.define do
  factory :account do
    email { Faker::Internet.email }
    password "password"
    password_confirmation "password"

    trait :with_organization do
      organization
    end

    trait :with_user do
      user
    end
  end
end
