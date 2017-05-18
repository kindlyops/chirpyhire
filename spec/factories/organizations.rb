FactoryGirl.define do
  factory :organization do
    name { Faker::Company.name }
    before(:create) do |organization|
      organization.location_attributes = attributes_for(:location, postal_code: '30342')
    end

    trait :team do
      after(:create) do |organization|
        create(:team, organization: organization)
      end
    end

    trait :account do
      after(:create) do |organization|
        account = create(:account, organization: organization)
        organization.update(recruiter: account)
      end
    end

    trait :recruiting_ad do
      after(:create) do |organization|
        create(:recruiting_ad, organization: organization)
      end
    end

    trait :phone_number do
      phone_number { Faker::PhoneNumber.cell_phone }
    end
  end
end
