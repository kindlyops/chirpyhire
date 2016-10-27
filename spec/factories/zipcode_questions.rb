FactoryGirl.define do
  factory :zipcode_question do
    survey
    text { Faker::Lorem.sentence }
    type ZipcodeQuestion.name
    sequence(:priority)
    sequence(:label) { |n| "label#{n}" }

    zipcode_question_options_attributes { [attributes_for(:zipcode_question_option)] }
  end
end
