FactoryGirl.define do
  factory :inquiry do
    candidate_feature
    user

    after(:create) do |inquiry|
      create(:message, inquiry: inquiry)
    end

    trait :with_answer do
      after(:create) do |inquiry|
        message = build(:message)
        message.media_instances.new(attributes_for(:media_instance))
        inquiry.create_answer(message: message, user: inquiry.user)
      end
    end
  end
end
