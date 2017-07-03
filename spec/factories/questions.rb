FactoryGirl.define do
  factory :question do
    bot
    body { Faker::Lorem.sentence }
  end

  factory :choice_question, parent: :question, class: 'ChoiceQuestion' do
    before(:create) do |question|
      break if question.rank.present?
      question.rank = question.bot.next_question_rank
    end
  end

  factory :zipcode_question, parent: :question, class: 'ZipcodeQuestion' do
    type { 'ZipcodeQuestion' }
  end
end
