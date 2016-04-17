FactoryGirl.define do
  factory :phone do
    organization
    title { "#{Faker::Company.name} Referrals" }
    number { Faker::PhoneNumber.phone_number }
  end
end
