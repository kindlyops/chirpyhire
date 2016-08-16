FactoryGirl.define do
  factory :account do
    user
    email { Faker::Internet.email }
    password "password"
    password_confirmation "password"

    trait :with_subscription do
      after(:create) do |account|
        create(:subscription, organization: account.organization)
      end
    end
  end
end
