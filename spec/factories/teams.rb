FactoryGirl.define do
  factory :team do
    name { Faker::Company.name }
    organization

    before(:create) do |team|
      team.location_attributes = attributes_for(:location)
    end

    trait :phone_number do
      phone_number { Faker::PhoneNumber.cell_phone }
    end
  end
end
