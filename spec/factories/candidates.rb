FactoryGirl.define do
  factory :candidate do
    user
    organization

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
        referrer = create(:referrer, organization: candidate.organization)
        message = create(:message, organization: candidate.organization)
        candidate.referrals.create(referrer: referrer, message: message)
      end
    end
  end
end
