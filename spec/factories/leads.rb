FactoryGirl.define do
  factory :lead do
    user
    organization

    trait :with_subscription do
      after(:create) do |lead|
        lead.subscribe
      end
    end

    trait :without_phone_number do
      association :user, :without_phone_number
    end

    trait :with_referral do
      after(:create) do |lead|
        referrer = create(:referrer, organization: lead.organization)
        message = create(:message, organization: lead.organization)
        lead.referrals.create(referrer: referrer, message: message)
      end
    end
  end
end
