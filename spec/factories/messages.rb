FactoryGirl.define do
  factory :message do
    sid { Faker::Number.number(10) }
    user
  end
end
