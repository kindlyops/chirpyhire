FactoryGirl.define do
  factory :notice do
    action

    transient do
      organization nil
    end

    before(:create) do |notice, evaluator|
      if evaluator.organization
        template = create(:template, organization: evaluator.organization)
      else
        template = create(:template)
      end
      notice.template = template
    end

    trait :with_notification do
      after(:create) do |notice|
        create(:notification, notice: notice)
      end
    end
  end
end
