FactoryGirl.define do
  factory :question_template do
    title { Faker::Company.buzzword }
    body { Faker::Company.buzzword }
    statement { Faker::Company.buzzword }
  end
end
