FactoryGirl.define do
  factory :organization do
    name { Faker::Company.name }
    phone_number { Faker::PhoneNumber.cell_phone }

    after(:create) do |organization|
      create(:location, organization: organization)
    end

    trait :with_subscription do
      after(:create) do |organization|
        create(:subscription, organization: organization)
      end
    end

    trait :with_survey do
      after(:create) do |organization|
        create(:survey, organization: organization)
      end
    end

    trait :with_account do
      after(:create) do |organization|
        create(:user, :with_account, organization: organization)
      end
    end

    # trait :with_templates do
    #   after(:create) do |organization|
        
    #   end
    # end

    # trait :with_rules do
    #   after(:create) do |organization|
    #     create(:rule, trigger: "subscribe", actionable: organization.survey.create_actionable, organization: organization)
    #     create(:rule, trigger: "answer", actionable: organization.survey.actionable, organization: organization)
    #     create(:rule, trigger: "screen", actionable: organization.thank_you.create_actionable, organization: organization)
    #     create(:rule, :with_account, organization: organization)
    #     create(:rule, :with_account, organization: organization)

    #         rules.create!(trigger: "subscribe", actionable: survey.create_actionable)
    # rules.create!(trigger: "answer", actionable: survey.actionable)
    # rules.create!(trigger: "screen", actionable: thank_you.create_actionable)
    #   end
    # end
  end
end
