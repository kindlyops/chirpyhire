FactoryGirl.define do
  factory :account do
    email { Faker::Internet.email }
    password 'password'
    association :organization, :subscription

    trait :owner do
      role :owner
    end

    trait :affiliate do
      affiliate_tag { 'tag' }
    end

    trait :person do
      after(:create) do |account|
        account.update(person: create(:person))
      end
    end

    trait :team do
      after(:create) do |account|
        team = create(:team, :inbox, organization: account.organization)
        team.accounts << account
      end
    end

    trait :team_with_phone_number_and_inbox do
      after(:create) do |account|
        team = create(:team, :phone_number, organization: account.organization)
        team.accounts << account
      end
    end
  end
end
