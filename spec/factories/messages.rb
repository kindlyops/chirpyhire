FactoryGirl.define do
  factory :message do
    association :sender, factory: :person
    direction { 'inbound' }
    sid { Faker::Number.number(10) }
    sent_at { DateTime.current }
    external_created_at { DateTime.current }
    from { Faker::PhoneNumber.cell_phone }
    to { Faker::PhoneNumber.cell_phone }
    body { Faker::Lorem.sentence }
    organization

    transient do
      conversation nil
    end

    after(:create) do |message, evaluator|
      next if evaluator.conversation.blank?

      create(:conversation_part,
             message: message, conversation: evaluator.conversation)
    end

    trait :conversation_part do
      after(:create) do |message, evaluator|
        next if message.conversation_part.present?
        conversation = evaluator.conversation || create(:conversation)

        create(:conversation_part,
               message: message,
               conversation: conversation)
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
