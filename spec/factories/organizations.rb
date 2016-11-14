FactoryGirl.define do
  factory :organization do
    name { Faker::Company.name }

    trait :with_location do
      after(:create) do |organization|
        create(:location, organization: organization)
      end
    end

    trait :with_subscription do
      after(:create) do |organization|
        create(:subscription, organization: organization)
      end
    end

    trait :with_survey do
      after(:create) do |organization|
        create(:survey, organization: organization)
      end
    end

    trait :with_account do
      after(:create) do |organization|
        create(:user, :with_account, organization: organization)
      end
    end
  end
end
