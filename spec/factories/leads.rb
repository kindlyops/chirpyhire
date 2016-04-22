FactoryGirl.define do
  factory :lead do
    user
    organization

    trait :with_subscription do
      after(:create) do |lead|
        lead.subscribe
      end
    end
  end
end
