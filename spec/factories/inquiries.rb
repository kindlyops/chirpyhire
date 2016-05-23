FactoryGirl.define do
  factory :inquiry do
    question
    message
    trait :with_image_question do
      association :question, format: :image
    end

    trait :with_text_question do
      association :question, format: :text
    end
  end
end
