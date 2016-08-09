FactoryGirl.define do
  factory :survey do
    organization
    association :welcome, factory: :template
    association :bad_fit, factory: :template
    association :thank_you, factory: :template

    trait :with_questions do
      after(:create) do |survey|
        create_list(:question, 2, survey: survey)
      end
    end
  end
end
