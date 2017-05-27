FactoryGirl.define do
  factory :read_receipt do
    message
    inbox_conversation
  end
end
