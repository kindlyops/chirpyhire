FactoryGirl.define do
  factory :person do
    phone_number { Faker::PhoneNumber.cell_phone }

    trait :with_subscribed_candidacy do
      after(:create) do |person|
        subscriber = create(:subscriber, person: person)
        person.candidacy.update(subscriber: subscriber)
      end
    end
  end
end
