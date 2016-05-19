FactoryGirl.define do
  factory :rule do
    organization
    trigger
    association :action, :with_notice
  end
end
