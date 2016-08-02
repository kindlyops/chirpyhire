FactoryGirl.define do
  factory :choice_question_option do
    letter { [*'a'..'z'].sample }
    text { Faker::Lorem.sentence }
  end
end
