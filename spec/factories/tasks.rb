FactoryGirl.define do
  factory :task do
    user
    association :taskable, factory: :message

    transient do
      organization nil
    end

    before(:create) do |task, evaluator|
      if evaluator.organization
        task.user = create(:user, organization: evaluator.organization)
      end
    end
  end
end
