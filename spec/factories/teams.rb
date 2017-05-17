FactoryGirl.define do
  factory :team do
    name { Faker::Company.name }

    before(:create) do |organization|
      organization.location_attributes = attributes_for(:location)
    end

    trait :phone_number do
      phone_number { Faker::PhoneNumber.cell_phone }
    end
  end
end
