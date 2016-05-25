FactoryGirl.define do
  factory :question do
    format :text
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
  end
end
