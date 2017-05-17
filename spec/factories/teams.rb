FactoryGirl.define do
  factory :team do
    organization
    name { Faker::Company.name }

    trait :phone_number do
      phone_number { Faker::PhoneNumber.cell_phone }
    end
  end
end
