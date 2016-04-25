FactoryGirl.define do
  factory :referrer do
    user
    organization

    trait :with_referral do
      after(:create) do |referrer|
        lead = create(:lead, organization: referrer.organization)
        message = create(:message, organization: referrer.organization)
        referrer.referrals.create(lead: lead, message: message)
      end
    end
  end
end
