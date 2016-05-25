Faker::Config.locale = 'en-US'

FactoryGirl.define do
  factory :phone do
    organization
    number "+15005550006"
  end
end
