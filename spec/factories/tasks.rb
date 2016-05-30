FactoryGirl.define do
  factory :task do
    user
    category "reply"

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
