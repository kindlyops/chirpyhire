FactoryGirl.define do
  factory :zipcode_question_option do
    text { Faker::Lorem.sentence }
  end
end
