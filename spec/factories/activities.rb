FactoryGirl.define do
  factory :activity do
    association :owner, factory: :user

    transient do
      organization nil
    end

    before(:create) do |activity, evaluator|
      if evaluator.organization
        activity.owner = create(:user, organization: evaluator.organization)
      end
    end
  end
end
