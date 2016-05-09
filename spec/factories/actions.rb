FactoryGirl.define do
  factory :action do
    trigger
    association :actionable, factory: :question
  end
end
