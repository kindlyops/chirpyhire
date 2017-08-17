FactoryGirl.define do
  factory :conversation do
    contact
    inbox
    phone_number

    trait :closed do
      state { 'Closed' }
      closed_at { DateTime.current }
    end
  end
end
