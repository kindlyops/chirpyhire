FactoryGirl.define do
  factory :bot do
    organization
    person
    name { Faker::Name.name }

    after(:create) do |bot|
      create(:greeting, bot: bot)
      create(:goal, bot: bot)
    end

    trait :question do
      after(:create) do |bot|
        create(:choice_question, bot: bot)
      end
    end
  end
end
