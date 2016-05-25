FactoryGirl.define do
  factory :automation do
    organization

    trait :with_rule do
      transient do
        answer false
      end

      after(:create) do |automation, evaluator|
        if evaluator.answer
          create(:rule, :answer, automation: automation)
        else
          create(:rule, automation: automation)
        end
      end
    end
  end
end
