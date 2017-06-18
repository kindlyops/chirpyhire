FactoryGirl.define do
  factory :team do
    organization
    name { Faker::Company.name }

    transient do
      with_inbox true
    end

    after(:create) do |team, evaluator|
      team.create_inbox if evaluator.with_inbox
    end

    before(:create) do |team|
      team.location_attributes = attributes_for(:location, postal_code: '30342')
    end

    trait :account do
      after(:create) do |team|
        account = create(:account, :inbox, organization: team.organization)
        team.accounts << account
        team.update(recruiter: account)
      end
    end

    trait :owner do
      after(:create) do |team|
        account = create(:account, :owner, organization: team.organization)
        team.accounts << account
        team.update(recruiter: account)
      end
    end

    trait :recruiting_ad do
      after(:create) do |team|
        create(:recruiting_ad, team: team)
      end
    end

    trait :phone_number do
      phone_number { Faker::PhoneNumber.cell_phone }
    end
  end
end
