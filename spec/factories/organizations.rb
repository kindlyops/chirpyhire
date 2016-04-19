FactoryGirl.define do
  factory :organization do
    name { Faker::Company.name }
    twilio_account_sid ENV.fetch('TWILIO_TEST_ACCOUNT_SID')
    twilio_auth_token ENV.fetch('TWILIO_TEST_AUTH_TOKEN')

    factory :organization_with_phone do
      after(:create) do |organization|
        create(:phone, organization: organization)
      end
    end

    factory :organization_with_successful_phone do
      after(:create) do |organization|
        create(:phone, :successful, organization: organization)
      end
    end

    factory :organization_with_phone_and_owner do
      after(:create) do |organization|
        create(:phone, organization: organization)
        create(:account, role: :owner, organization: organization, user: create(:user))
      end
    end
  end
end
