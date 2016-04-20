FactoryGirl.define do
  factory :question do
    organization
    label { Faker::Company.buzzword }
    body { Faker::Company.buzzword }
    statement { Faker::Company.buzzword }
  end
end
