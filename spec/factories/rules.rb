FactoryGirl.define do
  factory :rule do
    automation
    trigger

    before(:create) do |rule|
      rule.actionable = create(:notice, organization: rule.organization)
    end

    transient do
      format :text
    end


    trait :asks_question do
      before(:create) do |rule, evaluator|
        rule.actionable = create(:question, format: evaluator.format, organization: rule.organization)
      end
    end

    trait :answer do
      association :trigger, event: :answer

      after(:create) do |rule|
        create(:template, :with_question, organization: rule.organization)
      end
    end
  end
end
