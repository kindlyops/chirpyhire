FactoryGirl.define do
  factory :reminder do
    association :contact, :engaged, :subscribed
    event_at { DateTime.current }
  end
end
