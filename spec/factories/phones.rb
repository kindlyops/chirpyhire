FactoryGirl.define do
  factory :phone do
    organization
    title { "#{Faker::Company.name} Referrals" }
    number { Phony.normalize(Faker::PhoneNumber.phone_number) }
  end
end
