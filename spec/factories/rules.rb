FactoryGirl.define do
  factory :rule do
    automation
    trigger
    association :action, :with_notice
  end
end
