FactoryGirl.define do
  factory :choice_question do
    survey
    sequence(:label) { |n| "label#{n}" }
    sequence(:priority)
    type 'ChoiceQuestion'
    text { Faker::Lorem.sentence }

    choice_question_options_attributes { [attributes_for(:choice_question_option)] }
  end
end
