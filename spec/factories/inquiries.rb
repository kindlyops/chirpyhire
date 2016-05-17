FactoryGirl.define do
  factory :inquiry do
    question
    user
    message_sid { Faker::Number.number(10) }

    trait :with_image_question do
      association :question, format: Question.formats[:image]
    end

    trait :with_text_question do
      association :question, format: Question.formats[:text]
    end
  end
end
