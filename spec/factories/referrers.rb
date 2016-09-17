# frozen_string_literal: true
FactoryGirl.define do
  factory :referrer do
    user

    transient do
      organization nil
    end

    before(:create) do |referrer, evaluator|
      if evaluator.organization
        referrer.user = create(:user, organization: evaluator.organization)
      end
    end

    trait :with_referral do
      after(:create) do |referrer|
        candidate = create(:candidate, user: create(:user, organization: referrer.organization))
        referrer.referrals.create(candidate: candidate)
      end
    end
  end
end
