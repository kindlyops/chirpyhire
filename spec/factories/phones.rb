Faker::Config.locale = 'en-US'

FactoryGirl.define do
  factory :phone do
    organization
    number { Faker::PhoneNumber.cell_phone }

    trait :successful do
      number "+15005550006"
    end
  end
end
