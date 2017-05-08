FactoryGirl.define do
  factory :organization do
    name { Faker::Company.name }
    before(:create) do |organization|
      organization.location_attributes = attributes_for(:location)
    end

    after(:create) do |organization|
      create(:ideal_candidate, organization: organization)
      account = create(:account, organization: organization)
      organization.update(recruiter: account)
    end

    trait :phone_number do
      phone_number { Faker::PhoneNumber.cell_phone }
    end
  end
end
