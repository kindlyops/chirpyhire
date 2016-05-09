FactoryGirl.define do
  factory :trigger do
    organization
    association :observable, factory: :question

    trait :with_actions do
      after(:create) do |trigger|
        create_list(:action, 2, trigger: trigger)
      end
    end
  end
end
