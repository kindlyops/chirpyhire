FactoryGirl.define do
  factory :rule do
    automation
    trigger

    transient do
      format :text
    end

    before(:create) do |rule, evaluator|
      rule.actionable = create(:notice, organization: rule.organization)
    end

    trait :answer_trigger do
      before(:create) do |rule, evaluator|
        trigger = create(:trigger, event: :answer, organization: rule.organization)
        question = create(:question, trigger: trigger, organization: rule.organization)
        rule.trigger = trigger
      end
    end

    trait :asks_question do
      before(:create) do |rule, evaluator|
        rule.actionable = create(:question, format: evaluator.format, organization: rule.organization)
      end
    end
  end
end
