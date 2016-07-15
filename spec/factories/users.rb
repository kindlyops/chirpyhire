Faker::Config.locale = 'en-US'

FactoryGirl.define do
  factory :user do
    organization
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    phone_number { Faker::PhoneNumber.cell_phone }

    trait :with_account do
      after(:create) do |user|
        create(:account, user: user)
      end
    end

    trait :with_contact do
      contact { true }
    end

    trait :with_candidate do
      after(:create) do |user|
        create(:candidate, user: user)
      end
    end
  end
end
