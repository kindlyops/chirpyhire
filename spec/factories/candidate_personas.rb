FactoryGirl.define do
  factory :candidate_persona do
    organization

    trait :with_features do
      after(:create) do |persona|
        create_list(:persona_feature, 2, candidate_persona: persona)
      end
    end
  end
end
