FactoryGirl.define do
  factory :task do
    message

    transient do
      organization nil
    end

    before(:create) do |task, evaluator|
      if evaluator.organization
        user = create(:user, organization: evaluator.organization)
        task.message = create(:message, user: user)
      end
    end
  end
end
