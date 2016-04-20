FactoryGirl.define do
  factory :question do
    organization
    label { Faker::Company.buzzword }
    body { Faker::Company.buzzword }
    summary { Faker::Company.buzzword }
  end
end
