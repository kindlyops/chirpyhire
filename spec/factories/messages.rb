FactoryGirl.define do
  factory :message do
    user
    sid { Faker::Internet.password(34) }
  end
end
