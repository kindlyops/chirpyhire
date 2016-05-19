FactoryGirl.define do
  factory :rule do
    organization
    trigger_type "Candidate"
    event :subscribe
    association :action, factory: :notice

    trait :with_trigger do
      association :trigger, factory: :question
      event :answer
    end
  end
end
