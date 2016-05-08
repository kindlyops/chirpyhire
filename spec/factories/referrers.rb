FactoryGirl.define do
  factory :referrer do
    user
    organization

    trait :with_referral do
      after(:create) do |referrer|
        candidate = create(:candidate, organization: referrer.organization)
        referrer.referrals.create(candidate: candidate)
      end
    end
  end
end
