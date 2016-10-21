FactoryGirl.define do
  factory :user do
    organization
    phone_number { Faker::PhoneNumber.cell_phone }

    trait :with_account do
      after(:create) do |user|
        create(:account, user: user)
      end
    end

    trait :with_candidate do
      after(:create) do |user|
        create(:candidate, user: user)
      end
    end
  end
end
