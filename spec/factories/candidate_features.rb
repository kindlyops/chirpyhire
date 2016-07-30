FactoryGirl.define do
  factory :candidate_feature do
    candidate
    category

    trait :address do
      properties {
        { city: "Charlottesville",
          address: "1000 East Market Street, Charlottesville, VA, USA",
          country: "USA",
          latitude: Faker::Address.latitude,
          longitude: Faker::Address.longitude,
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
