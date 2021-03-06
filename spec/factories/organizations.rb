FactoryGirl.define do
  factory :organization do
    name { Faker::Company.name }

    trait :stages do
      after(:create) do |organization|
        organization.contact_stages.create(name: 'Potential', rank: 1)
        organization.contact_stages.create(name: 'Scheduled', rank: 2)
        organization.contact_stages.create(name: 'Not Now', rank: 3)
        organization.contact_stages.create(name: 'No Show', rank: 4)
        organization.contact_stages.create(name: 'Hired', rank: 5)
      end
    end

    trait :subscription do
      after(:create) do |organization|
        create(:subscription, organization: organization)
      end
    end

    trait :team do
      after(:create) do |organization|
        create(:team, :phone_number, organization: organization)
      end
    end

    trait :phone_number do
      after(:create) do |organization|
        create(:phone_number, organization: organization)
      end
    end

    trait :team_without_inbox do
      after(:create) do |organization|
        create(:team, organization: organization)
      end
    end

    trait :team_with_phone_number_and_recruiting_ad_and_inbox do
      after(:create) do |organization|
        create(:team, :phone_number, :recruiting_ad, :inbox, organization: organization)
      end
    end

    trait :account do
      after(:create) do |organization|
        team = create(:team, :inbox, :phone_number, organization: organization)
        account = create(:account, :person, organization: organization)
        team.accounts << account
        organization.update(recruiter: account)
      end
    end

    trait :recruiting_ad do
      after(:create) do |organization|
        create(:recruiting_ad, organization: organization)
      end
    end
  end
end
