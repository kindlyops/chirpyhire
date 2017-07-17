FactoryGirl.define do
  factory :team do
    organization
    name { Faker::Company.name }

    trait :inbox do
      after(:create) do |team|
        team.create_inbox if team.inbox.blank?
      end
    end

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
      after(:create) do |team|
        team.create_inbox if team.inbox.blank?
        phone_number = create(:phone_number, organization: team.organization)
        create(:assignment_rule, organization: team.organization, inbox: team.inbox, phone_number: phone_number)
        bot = team.organization.bots.first || create(:bot, organization: team.organization)
        campaign = create(:campaign, organization: team.organization)
        bot.bot_campaigns.create(campaign: campaign, inbox: team.inbox)
      end
    end
  end
end
