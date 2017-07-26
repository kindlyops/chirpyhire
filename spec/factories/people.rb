FactoryGirl.define do
  factory :person do
    organization
    phone_number { Faker::PhoneNumber.cell_phone }

    trait :with_name do
      name { Faker::Name.name }
    end

    trait :with_zipcode do
      after(:create) do |person|
        zipcode = create(:zipcode)
        person.update(zipcode: zipcode)
      end
    end
  end
end
