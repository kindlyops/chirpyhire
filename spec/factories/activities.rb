FactoryGirl.define do
  factory :activity do
    association :owner, factory: :user

    transient do
      organization nil
    end

    before(:create) do |activity, evaluator|
      unless activity.trackable
        activity.trackable = create(:chirp, :with_message, user: activity.owner)
        activity.key = 'chirp.create'
      end

      if evaluator.organization
        activity.owner = create(:user, organization: evaluator.organization)
      end
    end
  end
end
