FactoryGirl.define do
  factory :rule do
    organization
    trigger

    transient do
      format :text
    end

    before(:create) do |rule, evaluator|
      rule.action = create(:template, organization: rule.organization)
    end

    trait :screen_trigger do
      before(:create) do |rule, evaluator|
        trigger = create(:trigger, event: :screen, organization: rule.organization)
        rule.trigger = trigger
      end
    end
  end
end
