FactoryGirl.define do
  factory :organization do
    name { Faker::Company.name }

    after(:create) do |organization|
      create(:location, organization: organization)
      create(:ideal_candidate, organization: organization)
    end

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
