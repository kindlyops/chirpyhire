FactoryGirl.define do
  factory :follow_up do
    question
    body { Faker::Lorem.sentence }
    response { Faker::Lorem.sentence }
    bot_action_id { create(:bot_action).id }
    before(:create) do |follow_up|
      next if follow_up.rank.present?
      follow_up.rank = follow_up.question.next_follow_up_rank
    end
  end

  factory :zipcode_follow_up, parent: :follow_up, class: 'ZipcodeFollowUp' do
    association :question, factory: :zipcode_question
    bot_action_id { create(:bot_action).id }
    type { 'ZipcodeFollowUp' }
    before(:create) do |follow_up|
      next if follow_up.rank.present?
      follow_up.rank = follow_up.question.next_follow_up_rank
    end
  end

  factory :choice_follow_up, parent: :follow_up, class: 'ChoiceFollowUp' do
    association :question, factory: :choice_question
    bot_action_id { create(:bot_action).id }
    type { 'ChoiceFollowUp' }
    response { Faker::Lorem.sentence }
    before(:create) do |follow_up|
      next if follow_up.rank.present?
      follow_up.rank = follow_up.question.next_follow_up_rank
    end
  end
end
