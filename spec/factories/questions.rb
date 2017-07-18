FactoryGirl.define do
  factory :question do
    bot
    body { Faker::Lorem.sentence }

    after(:create) do |question|
      create(:follow_up, question: question)
    end
  end

  factory :choice_question, parent: :question, class: 'ChoiceQuestion' do
    type { 'ChoiceQuestion' }

    after(:create) do |question|
      create(:choice_follow_up, question: question)
    end
  end

  factory :zipcode_question, parent: :question, class: 'ZipcodeQuestion' do
    type { 'ZipcodeQuestion' }

    after(:create) do |question|
      create(:zipcode_follow_up, question: question)
    end
  end
end
