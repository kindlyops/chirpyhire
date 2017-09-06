FactoryGirl.define do
  factory :conversation do
    contact
    inbox
    phone_number

    trait :closed do
      state { 'Closed' }
      closed_at { DateTime.current }
    end

    trait :message do
      after(:create) do |conversation|
        create(:conversation_part, conversation: conversation)
      end
    end
  end
end
