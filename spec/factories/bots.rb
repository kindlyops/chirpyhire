FactoryGirl.define do
  factory :bot do
    organization
    person
    account
    association :last_edited_by, factory: :account
    last_edited_at { DateTime.current }

    name { Faker::Name.name }

    after(:create) do |bot|
      create(:bot_action, bot: bot, type: 'NextQuestionAction')
      bot.actions.create(
        type: 'GoalAction', goal_id: create(:goal, bot: bot).id
      )
      create(:greeting, bot: bot)
    end

    trait :question do
      after(:create) do |bot|
        create(:choice_question, bot: bot)
      end
    end
  end
end
