FactoryGirl.define do
  factory :candidate do
    user

    transient do
      inquiry_format :text
      organization nil
      latitude nil
      longitude nil
      zipcode nil
      address_zipcode nil
      subscribed nil
    end

    trait :with_subscription do
      subscribed { true }
    end

    before(:create) do |candidate, evaluator|
      if evaluator.organization
        candidate.user = create(:user, organization: evaluator.organization)
      end
    end

    after(:create) do |candidate, evaluator|
      if evaluator.zipcode
        create(:candidate_feature, candidate: candidate, zipcode: evaluator.zipcode)
      end
    end

    trait :with_address do
      after(:create) do |candidate, evaluator|
        if evaluator.latitude && evaluator.longitude
          create(:candidate_feature, :address, candidate: candidate, latitude: evaluator.latitude, longitude: evaluator.longitude)
        elsif evaluator.address_zipcode
          create(:candidate_feature, :address, candidate: candidate, address_zipcode: evaluator.address_zipcode)
        else
          create(:candidate_feature, :address, candidate: candidate)
        end
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
