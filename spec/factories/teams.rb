FactoryGirl.define do
  factory :team do
    organization
    name { Faker::Company.name }

    before(:create) do |team|
      team.location_attributes = attributes_for(:location, postal_code: '30342')
    end

    trait :account do
      after(:create) do |team|
        account = create(:account, organization: team.organization)
        team.accounts << account
        team.update(recruiter: account)
      end
    end

    trait :phone_number do
      phone_number { Faker::PhoneNumber.cell_phone }
    end
  end
end
