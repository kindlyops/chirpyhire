FactoryGirl.define do
  factory :broker do
    twilio_account_sid { 'ACCOUNT_SID' }
    twilio_auth_token { 'AUTH_TOKEN' }
    phone_number { Faker::PhoneNumber.cell_phone }
  end
end
