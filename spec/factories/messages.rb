FactoryGirl.define do
  factory :message do
    association :sender, factory: :person
    direction { 'inbound' }
    sid { Faker::Number.number(10) }
    sent_at { DateTime.current }
    external_created_at { DateTime.current }
    conversation
    from { Faker::PhoneNumber.cell_phone }
    to { Faker::PhoneNumber.cell_phone }
    body { Faker::Lorem.sentence }
    organization

    trait :conversation_part do
      after(:create) do |message|
        create(:conversation_part,
               message: message,
               conversation: message.conversation)
      end
    end

    trait :to do
      after(:create) do |message|
        organization = message.organization
        phone_number = create(:phone_number, organization: organization)
        message.update(to: phone_number.phone_number)
      end
    end
  end
end
