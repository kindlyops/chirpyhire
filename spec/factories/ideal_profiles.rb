FactoryGirl.define do
  factory :ideal_profile do
    organization

    trait :with_features do
      after(:create) do |profile|
        create_list(:ideal_feature, 2, ideal_profile: profile)
      end
    end
  end
end
