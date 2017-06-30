FactoryGirl.define do
  factory :phone_number do
    phone_number { Faker::PhoneNumber.cell_phone }
    sid { Faker::Number.number(10) }
    organization
  end
end
