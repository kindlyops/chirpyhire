FactoryGirl.define do
  factory :notice do

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
  end
end
