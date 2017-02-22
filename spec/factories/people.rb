FactoryGirl.define do
  factory :person do
    phone_number { Faker::PhoneNumber.cell_phone }

    trait :with_subscribed_candidacy do
      after(:create) do |person|
        contact = create(:contact, person: person)
        person.candidacy.update(contact: contact)
      end
    end
  end
end
