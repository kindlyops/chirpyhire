FactoryGirl.define do
  factory :answer do
    question
    lead
    message
    body { Faker::Company.buzzword }
  end
end
