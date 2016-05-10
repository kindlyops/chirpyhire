FactoryGirl.define do
  factory :trigger do
    organization
    observable_type "Subscription"
    operation :subscribe

    trait :with_observable do
      association :observable, factory: :question
      operation :answer
    end

    trait :with_actions do
      after(:create) do |trigger|
        create_list(:action, 2, trigger: trigger)
      end
    end
  end
end
