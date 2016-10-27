FactoryGirl.define do
  factory :question do
    survey
    sequence(:priority)
    sequence(:label) { |n| "label#{n}" }
    type { %w(AddressQuestion ChoiceQuestion DocumentQuestion YesNoQuestion, ZipcodeQuestion).sample }
    text { Faker::Lorem.sentence }

    trait :document do
      type DocumentQuestion.name
    end

    trait :choice do
      type ChoiceQuestion.name

      after(:create) do |question|
        create(:choice_question_option, choice_question: ChoiceQuestion.find(question.id))
      end
    end
  end
end
