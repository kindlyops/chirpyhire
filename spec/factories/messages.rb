FactoryGirl.define do
  factory :message do
    organization
    person
    direction { 'inbound' }
    sid { Faker::Number.number(10) }
    sent_at { DateTime.current }
    external_created_at { DateTime.current }
  end
end
