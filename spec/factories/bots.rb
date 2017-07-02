FactoryGirl.define do
  factory :bot do
    organization
    greeting
    name { Faker::Name.name }

    after(:create) do |bot|
      create(:goal, bot: bot)
    end
  end
end
