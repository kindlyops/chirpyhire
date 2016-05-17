FactoryGirl.define do
  factory :referrer do
    user

    trait :with_referral do
      after(:create) do |referrer|
        candidate = create(:candidate, user: create(:user, organization: referrer.organization))
        referrer.referrals.create(candidate: candidate)
      end
    end
  end
end
