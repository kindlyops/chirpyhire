FactoryGirl.define do
  factory :trigger do
    organization
    observable_type "Candidate"
    operation :subscribe

    trait :with_observable do
      association :observable, factory: :question
      operation :answer
    end

    trait :with_actions do
      after(:create) do |trigger|
        create(:action, trigger: trigger)
        create(:action, :with_notice, trigger: trigger)
      end
    end
  end
end
