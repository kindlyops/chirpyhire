FactoryGirl.define do
  factory :message do
    direction { 'inbound' }
    sid { Faker::Number.number(10) }
    association :user, :with_candidate

    trait :with_image do
      after(:create) do |message|
        create(:media_instance, message: message)
      end
    end

    trait :with_address do
      body '4059 Mt Lee Dr 90068'
    end

    after(:create) do |message, evaluator|
      unless evaluator.created_at.present?
        message.update(external_created_at: message.created_at, sent_at: message.created_at)
      end
    end
  end
end
