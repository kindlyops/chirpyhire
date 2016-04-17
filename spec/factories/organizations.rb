FactoryGirl.define do
  factory :organization do
    name { Faker::Company.name }
    twilio_account_sid ENV.fetch("TWILIO_TEST_ACCOUNT_SID")
    twilio_auth_token ENV.fetch("TWILIO_TEST_AUTH_TOKEN")
  end
end
