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
          postal_code: Faker::Address.zip_code,
          child_class: AddressQuestion.child_class_property }
      }
    end

    transient do
      user nil
      latitude nil
      longitude nil
      zipcode nil
    end

    before(:create) do |candidate_feature, evaluator|
      if evaluator.user
        candidate_feature.candidate = create(:candidate, user: evaluator.user)
      end

      if evaluator.latitude && evaluator.longitude
        candidate_feature['properties']['latitude'] = evaluator.latitude
        candidate_feature['properties']['longitude'] = evaluator.longitude
      end

      if evaluator.zipcode
        candidate_feature['properties']['option'] = evaluator.zipcode
        candidate_feature['properties']['child_class'] =
          ZipcodeQuestion.child_class_property
      end
    end
  end
end
