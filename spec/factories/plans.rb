FactoryGirl.define do
  factory :plan do
    amount 5_000
    interval 'monthly'
    name 'Basic'
    stripe_id '1'
  end
end
