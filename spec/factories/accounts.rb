FactoryGirl.define do
  factory :account do
    email { Faker::Internet.email }
    password 'password'
    organization

    trait :owner do
      role :owner
    end

    trait :team do
      after(:create) do |account|
        team = create(:team, :inbox, organization: account.organization)
        team.accounts << account
        team.update(recruiter: account)
      end
    end

    trait :team_with_phone_number_and_inbox do
      after(:create) do |account|
        team = create(:team, :phone_number, organization: account.organization)
        team.accounts << account
        team.update(recruiter: account)
      end
    end
  end
end
