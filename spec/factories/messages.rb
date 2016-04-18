FactoryGirl.define do
  factory :message do
    organization
    sid { Faker::Internet.password(34) }
  end
end
