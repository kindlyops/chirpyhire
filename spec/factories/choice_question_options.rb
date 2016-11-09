FactoryGirl.define do
  factory :choice_question_option do
    letter { [*'a'..'m'].sample }
    text { Faker::Lorem.sentence }
  end
end
