FactoryGirl.define do
  factory :message do
    user
    direction { "inbound" }
    sid { Faker::Number.number(10) }

    trait :with_image do
      after(:create) do |message|
        create(:media_instance, message: message)
      end
    end
  end
end
