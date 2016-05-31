FactoryGirl.define do
  factory :profile do
    organization

    trait :with_features do
      after(:create) do |profile|
        create_list(:profile_feature, 2, profile: profile)
      end
    end
  end
end
