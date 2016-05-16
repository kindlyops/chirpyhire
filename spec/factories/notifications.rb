FactoryGirl.define do
  factory :notification do
    message_sid { Faker::Number.number(10) }
    notice
    user
  end
end
