FactoryGirl.define do
  factory :answer do
    inquiry
    user
    message_sid { Faker::Number.number(10) }
  end
end
