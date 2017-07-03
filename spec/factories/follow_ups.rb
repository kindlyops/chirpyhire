FactoryGirl.define do
  factory :follow_up do
    body { Faker::Lorem.sentence }

    trait :choice do
      response { Faker::Lorem.sentence }
      before(:create) do |follow_up|
        break if follow_up.rank.present?
        follow_up.rank = follow_up.question.next_follow_up_rank
      end
    end
  end
end
