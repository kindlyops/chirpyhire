FactoryGirl.define do
  factory :account do
    association :person, :with_name
    email { Faker::Internet.email }
    password 'password'
    organization

    trait :team do
      after(:create) do |account|
        team = create(:team, organization: account.organization)
        team.accounts << account
      end
    end
  end
end
