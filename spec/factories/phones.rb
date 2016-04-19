Faker::Config.locale = 'en-US'

FactoryGirl.define do
  factory :phone do
    organization
    title { "#{Faker::Company.name} Referrals" }
    number { Faker::PhoneNumber.cell_phone }

    trait :successful do
      number "+15005550006"
    end
  end
end
