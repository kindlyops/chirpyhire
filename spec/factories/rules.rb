FactoryGirl.define do
  factory :rule do
    organization
    trigger { "subscribe" }

    transient do
      format :text
    end

    before(:create) do |rule, evaluator|
      rule.action = create(:template, organization: rule.organization)
    end
  end
end
