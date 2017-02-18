FactoryGirl.define do
  factory :plan do
    amount 5_000
    interval 'monthly'
    name 'Basic'
    sequence(:stripe_id)
  end
end
