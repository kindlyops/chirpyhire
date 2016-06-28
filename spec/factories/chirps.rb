FactoryGirl.define do
  factory :chirp do
    user
    message_attributes { attributes_for(:message) }
  end
end
