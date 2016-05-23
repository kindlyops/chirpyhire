FactoryGirl.define do
  factory :automation do
    organization

    trait :with_rule do
      after(:create) do |automation|
        create(:rule, automation: automation)
      end
    end
  end
end
