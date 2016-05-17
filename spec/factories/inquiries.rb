FactoryGirl.define do
  factory :inquiry do
    question
    user
    message_sid { Faker::Number.number(10) }

    trait :with_media_question do
      association :question, format: Question.formats[:media]
    end

    trait :with_text_question do
      association :question, format: Question.formats[:text]
    end
  end
end
