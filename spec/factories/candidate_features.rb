FactoryGirl.define do
  factory :candidate_feature do
    candidate
    category
    before(:create) do |candidate_feature|
      unless candidate_feature.persona_feature.present?
        candidate_feature.persona_feature = create(:persona_feature, candidate_persona: candidate_feature.candidate.candidate_persona)
      end
    end

    trait :address do
      properties {
        { city: "Charlottesville",
          address: "1000 East Market Street, Charlottesville, VA, USA",
          country: "USA",
          latitude: 38.028531,
          longitude: -78.473088,
          postal_code: "22902",
          child_class: "address"
        }
      }
    end

    transient do
      user nil
    end

    before(:create) do |candidate_feature, evaluator|
      if evaluator.user
        candidate_feature.candidate = create(:candidate, user: evaluator.user)
      end
    end
  end
end
