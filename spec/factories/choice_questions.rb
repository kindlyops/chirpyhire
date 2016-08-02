FactoryGirl.define do
  factory :choice_question do
    survey
    category
    sequence(:priority)
    type "ChoiceQuestion"
    text { Faker::Lorem.sentence }

    trait :with_options do
      after(:create) do |question|
        create(:choice_question_option, question: question)
      end
    end
  end
end
