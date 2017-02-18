FactoryGirl.define do
  factory :organization do
    name { Faker::Company.name }
    zip_code { '30342' }

    trait :with_subscription do
      after(:create) do |organization|
        create(:subscription, organization: organization)
      end
    end

    trait :with_account do
      after(:create) do |organization|
        create(:account, organization: organization)
      end
    end
  end
end
