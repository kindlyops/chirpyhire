FactoryGirl.define do
  factory :payment_card do
    brand { 'Visa' }
    exp_month { 12 }
    exp_year { 2024 }
    last4 { 1234 }
  end
end
