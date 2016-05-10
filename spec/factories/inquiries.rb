FactoryGirl.define do
  factory :inquiry do
    question
    message

    trait :with_media_question do
      association :question, format: Question.formats[:media]
    end

    trait :with_text_question do
      association :question, format: Question.formats[:text]
    end
  end
end
