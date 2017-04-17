FactoryGirl.define do
  factory :phone_number do
    phone_number { Faker::PhoneNumber.cell_phone }
  end
end
