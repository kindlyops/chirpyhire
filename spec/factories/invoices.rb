FactoryGirl.define do
  factory :invoice do
    subscription
    stripe_id '1'
  end
end
