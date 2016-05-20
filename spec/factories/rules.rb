FactoryGirl.define do
  factory :rule do
    automation
    trigger
    association :action, :with_notice

    trait :answer do
      association :trigger, event: :answer
      after(:create) do |rule|
        create(:question, trigger: rule.trigger)
      end
    end
  end
end
