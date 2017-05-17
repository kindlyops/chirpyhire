FactoryGirl.define do
  factory :organization do
    name { Faker::Company.name }

    trait :account do
      after(:create) do |organization|
        create(:account, organization: organization)
      end
    end

    trait :team do
      after(:create) do |organization|
        create(:team, organization: organization)
      end
    end
  end
end
