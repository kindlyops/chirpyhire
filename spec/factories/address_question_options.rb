FactoryGirl.define do
  factory :address_question_option do
    distance { Faker::Number.number(2) }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
  end
end
