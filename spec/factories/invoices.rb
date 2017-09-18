FactoryGirl.define do
  factory :invoice do
    subscription
    stripe_id { "id_#{Faker::Lorem.characters(26)}" }
    date { Faker::Date.backward(14).to_time.to_i }
    period_end { Faker::Date.backward(14).to_time.to_i }
    period_start { Faker::Date.backward(14).to_time.to_i }
    total { Faker::Number.between(12_500, 200_000) }
    closed { [true, false].sample }
    forgiven { [true, false].sample }
    paid { [true, false].sample }
    attempted { [true, false].sample }
  end
end
