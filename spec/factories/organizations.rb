FactoryGirl.define do
  factory :organization do
    name { Faker::Company.name }

    after(:create) do |organization|
      create(:location, organization: organization)
      create(:ideal_candidate, organization: organization)
      account = create(:account, organization: organization)
      organization.update(recruiter: account)
    end
  end
end
