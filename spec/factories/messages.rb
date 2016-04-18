FactoryGirl.define do
  factory :message do
    sid { Faker::Internet.password(34) }
  end
end
