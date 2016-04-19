FactoryGirl.define do
  factory :search do
    organization
    label { Faker::Company.buzzword }
  end
end
