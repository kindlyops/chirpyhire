FactoryGirl.define do
  factory :question do
    bot
    body { Faker::Lorem.sentence }

    trait :choice do
      before(:create) do |question|
        break if question.rank.present?
        question.rank = question.bot.next_question_rank
      end
    end
  end
end
