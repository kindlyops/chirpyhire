FactoryGirl.define do
  factory :survey do
    organization

    trait :with_questions do
      after(:create) do |survey|
        create_list(:question, 2, survey: survey)
      end
    end
  end
end
