FactoryGirl.define do
  factory :candidate do
    user

    transient do
      inquiry_format :text
    end

    trait :with_subscription do
      subscribed { true }
    end

    trait :with_inquiry do
      after(:create) do |candidate, evaluator|
        automation = create(:automation, organization: candidate.organization)
        rule = create(:rule, :asks_question, format: evaluator.inquiry_format, automation: automation)
        rule.perform(candidate.user)
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
