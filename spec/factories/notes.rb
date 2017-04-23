FactoryGirl.define do
  factory :note do
    account
    contact
    body { Faker::Lorem.sentence }
  end
end
