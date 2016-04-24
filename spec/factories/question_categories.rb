FactoryGirl.define do
  factory :question_category do
    name { Faker::Company.buzzword }
  end
end
