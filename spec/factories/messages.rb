FactoryGirl.define do
  factory :message do
    organization
    user
    sid { Faker::Internet.password(34) }
  end
end
