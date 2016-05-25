FactoryGirl.define do
  factory :question do
    transient do
      organization nil
    end

    before(:create) do |question, evaluator|
      if evaluator.organization
        template = create(:template, organization: evaluator.organization)
      else
        template = create(:template)
      end
      question.template = template
    end

    format "text"

    trait :with_inquiry do
      after(:create) do |question|
        create(:inquiry, question: question)
      end
    end
  end
end
