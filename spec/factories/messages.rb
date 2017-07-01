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
  end
end
