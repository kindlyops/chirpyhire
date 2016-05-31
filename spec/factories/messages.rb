FactoryGirl.define do
  factory :message do
    user
    direction { "inbound" }
    sid { Faker::Number.number(10) }
  end
end
