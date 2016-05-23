FactoryGirl.define do
  factory :template do
    organization
    name { Faker::Lorem.words(rand(1..3)).join }
    body { Faker::Lorem.paragraph(rand(1..5)) }

    trait :with_question do
      question
    end
  end
end
