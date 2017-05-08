FactoryGirl.define do
  factory :person do
    phone_number { Faker::PhoneNumber.cell_phone }

    trait :with_name do
      name { Faker::Name.name }
    end

    trait :with_candidacy do
      after(:create) do |person|
        person.candidacy || person.create_candidacy
      end
    end

    trait :with_broker_candidacy do
      after(:create) do |person|
        person.broker_candidacy || person.create_broker_candidacy
      end
    end

    trait :with_subscribed_candidacy do
      after(:create) do |person|
        person.create_candidacy
        contact = create(:contact, person: person)
        person.candidacy.update(contact: contact)
      end
    end

    trait :with_broker_subscribed_candidacy do
      after(:create) do |person|
        person.create_broker_candidacy
        broker_contact = create(:broker_contact, person: person)
        person.broker_candidacy.update(broker_contact: broker_contact)
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
