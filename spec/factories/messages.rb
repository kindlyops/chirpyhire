FactoryGirl.define do
  factory :message do
    user
    sid { Faker::Number.number(10) }
  end
end
