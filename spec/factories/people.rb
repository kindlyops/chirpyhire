FactoryGirl.define do
  factory :person do
    phone { Faker::PhoneNumber.cell_phone }

    trait :with_subscribed_candidacy do
      after(:create) do |person|
        contact = create(:contact, person: person)
        person.candidacy.update(contact: contact)
      end
    end

    trait :with_zipcode do
      after(:create) do |person|
        zipcode = create(:zipcode)
        person.update(zipcode: zipcode)
      end
    end
  end
end
