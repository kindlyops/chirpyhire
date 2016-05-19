FactoryGirl.define do
  factory :rule do
    organization
    trigger
    association :action, factory: :notice
  end
end
