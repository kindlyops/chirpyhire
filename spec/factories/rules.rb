FactoryGirl.define do
  factory :rule do
    organization
    trigger

    transient do
      format :text
    end

    before(:create) do |rule, evaluator|
      rule.action = create(:notice, organization: rule.organization)
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
        rule.action = create(:question, format: evaluator.format, organization: rule.organization)
      end
    end
  end
end
