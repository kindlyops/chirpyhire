FactoryGirl.define do
  factory :candidate_feature do
    candidate
    sequence(:label) { |n| "label#{n}" }

    trait :address do
      properties do
        { city: 'Atlanta',
          address: Faker::Address.street_address,
          country: 'USA',
          latitude:  rand(33.624972..34.109784),
          longitude:  rand(-84.633424..-84.144741),
          postal_code: Faker::Address.zip_code,
          child_class: 'address' }
      end
    end

    transient do
      user nil
      latitude nil
      longitude nil
    end

    before(:create) do |candidate_feature, evaluator|
      if evaluator.user
        candidate_feature.candidate = create(:candidate, user: evaluator.user)
      end

      if evaluator.latitude && evaluator.longitude
        candidate_feature['properties']['latitude'] = evaluator.latitude
        candidate_feature['properties']['longitude'] = evaluator.longitude
      end
    end
  end
end
