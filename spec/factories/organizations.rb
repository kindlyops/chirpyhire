FactoryGirl.define do
  factory :organization do
    name { Faker::Company.name }
    domain { Faker::Internet.domain_name }

    factory :organization_with_phone do
      after(:create) do |organization|
        create(:phone, organization: organization)
      end
    end
  end
end
