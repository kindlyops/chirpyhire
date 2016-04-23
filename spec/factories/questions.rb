FactoryGirl.define do
  factory :question do
    organization
    title { Faker::Company.buzzword }
    body { Faker::Company.buzzword }
    statement { Faker::Company.buzzword }
  end
end
