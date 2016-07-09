FactoryGirl.define do
  factory :inquiry do
    candidate_feature
    message

    trait :with_answer do
      after(:create) do |inquiry|
        answer_message = create(:message, user: inquiry.message.user)
        answer_message.media_instances.create(attributes_for(:media_instance))
        inquiry.create_answer(message: answer_message)
      end
    end
  end
end
