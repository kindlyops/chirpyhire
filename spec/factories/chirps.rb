FactoryGirl.define do
  factory :chirp do
    user

    trait :with_message do
      message_attributes { attributes_for(:message) }
    end
  end
end
