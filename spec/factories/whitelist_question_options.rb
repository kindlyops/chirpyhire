FactoryGirl.define do
  factory :whitelist_question_option do
    text { Faker::Lorem.sentence }
  end
end
