FactoryGirl.define do
  factory :candidate do
    user

    trait :with_subscription do
      subscribed { true }
    end

    trait :with_referral do
      after(:create) do |candidate|
        referrer = create(:referrer)
        candidate.referrals.create(referrer: referrer)
      end
    end
  end
end
