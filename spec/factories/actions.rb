FactoryGirl.define do
  factory :action do
    rule
    association :actionable, factory: :question

    trait :with_notice do
      association :actionable, factory: :notice
    end
  end
end
