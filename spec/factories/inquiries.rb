FactoryGirl.define do
  factory :inquiry do
    message

    before(:create) do |inquiry|
      unless inquiry.question.present?
        inquiry.question = create(:question, survey: inquiry.organization.create_survey)
      end
    end

    trait :document_question do
      association :question, :document
    end

    trait :with_answer do
      after(:create) do |inquiry|
        answer_message = create(:message, user: inquiry.message.user)
        answer_message.media_instances.create(attributes_for(:media_instance))
        inquiry.create_answer(message: answer_message)
      end
    end
  end
end
