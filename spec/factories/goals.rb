FactoryGirl.define do
  factory :goal do
    body { Faker::Lorem.sentence }

    before(:create) do |goal|
      break if goal.rank.present?
      goal.rank = goal.bot.next_question_rank
    end
  end
end
