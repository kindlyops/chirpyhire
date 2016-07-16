FactoryGirl.define do
  factory :inquiry do
    message

    before(:create) do |inquiry|
      inquiry.persona_feature = create(:persona_feature, candidate_persona: inquiry.organization.candidate_persona)
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
