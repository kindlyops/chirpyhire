FactoryGirl.define do
  factory :question do
    bot
    body { Faker::Lorem.sentence }

    follow_ups_attributes { [attributes_for(:follow_up)] }
  end

  factory :choice_question, parent: :question, class: 'ChoiceQuestion' do
    type { 'ChoiceQuestion' }
    follow_ups_attributes { [attributes_for(:choice_follow_up)] }
  end

  factory :zipcode_question, parent: :question, class: 'ZipcodeQuestion' do
    type { 'ZipcodeQuestion' }
    follow_ups_attributes { [attributes_for(:zipcode_follow_up)] }
  end
end
