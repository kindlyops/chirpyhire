FactoryGirl.define do
  factory :question do
    survey
    category
    sequence(:priority)
    sequence(:label) { |n| "label#{n}" }
    type { %w(AddressQuestion ChoiceQuestion DocumentQuestion).sample }
    text { Faker::Lorem.sentence }

    trait :document do
      type "DocumentQuestion"
    end

    trait :choice do
      type "ChoiceQuestion"

      after(:create) do |question|
        create(:choice_question_option, choice_question: ChoiceQuestion.find(question.id))
      end
    end
  end
end
