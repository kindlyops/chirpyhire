FactoryGirl.define do
  factory :person do
    phone_number { Faker::PhoneNumber.cell_phone }
  end
end
