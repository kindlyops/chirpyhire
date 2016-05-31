FactoryGirl.define do
  factory :candidate do
    user

    transient do
      inquiry_format :text
      organization nil
    end

    trait :with_subscription do
      subscribed { true }
    end

    before(:create) do |candidate, evaluator|
      if evaluator.organization
        candidate.user = create(:user, organization: evaluator.organization)
      end
    end

    trait :with_inquiry do
      after(:create) do |candidate, evaluator|
        candidate_feature = create(:candidate_feature, candidate: candidate)
        candidate_feature.inquiries << create(:inquiry, message: create(:message, user: candidate.user))
      end
    end

    trait :with_referral do
      after(:create) do |candidate|
        referrer = create(:referrer)
        candidate.referrals.create(referrer: referrer)
      end
    end
  end
end
