FactoryGirl.define do
  factory :candidate_feature do
    candidate
    sequence(:label) { |n| "label#{n}" }

    trait :address do
      properties {
        { city: 'Atlanta',
          address: Faker::Address.street_address,
          country: 'USA',
          latitude:  rand(33.624972..34.109784),
          longitude:  rand(-84.633424..-84.144741),
          postal_code: Faker::Address.zip_code(state_code || 'GA'),
          child_class: AddressQuestion.child_class_property }
      }
    end

    transient do
      user nil
      latitude nil
      longitude nil
      zipcode nil
      address_zipcode nil
      state_code nil
    end

    before(:create) do |candidate_feature, evaluator|
      if evaluator.user
        candidate_feature.candidate = create(:candidate, user: evaluator.user)
      end

      if evaluator.latitude && evaluator.longitude
        candidate_feature['properties']['latitude'] = evaluator.latitude
        candidate_feature['properties']['longitude'] = evaluator.longitude
      end
      if evaluator.address_zipcode
        candidate_feature['properties']['postal_code'] = evaluator.address_zipcode
      end

      if evaluator.zipcode
        candidate_feature['properties']['option'] = evaluator.zipcode
        candidate_feature['properties']['child_class'] =
          ZipcodeQuestion.child_class_property
      end

    end
  end
end
