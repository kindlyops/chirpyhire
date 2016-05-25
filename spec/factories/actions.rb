FactoryGirl.define do
  factory :action do
    organization

    trait :with_question do
      after(:create) do |action|
        template = create(:template, organization: action.organization)
        create(:question, template: template, action: action)
      end
    end

    trait :with_notice do
      after(:create) do |action|
        template = create(:template, organization: action.organization)
        create(:notice, template: template, action: action)
      end
    end
  end
end
