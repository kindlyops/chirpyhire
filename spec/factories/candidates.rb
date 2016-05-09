FactoryGirl.define do
  factory :candidate do
    user

    trait :with_subscription do
      after(:create) do |candidate|
        candidate.subscribe
      end
    end

    trait :without_phone_number do
      association :user, :without_phone_number
    end

    trait :with_referral do
      after(:create) do |candidate|
        referrer = create(:referrer)
        candidate.referrals.create(referrer: referrer)
      end
    end
  end
end
