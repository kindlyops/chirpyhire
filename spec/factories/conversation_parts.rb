FactoryGirl.define do
  factory :conversation_part do
    happened_at { DateTime.current }
    conversation
    message
  end
end
