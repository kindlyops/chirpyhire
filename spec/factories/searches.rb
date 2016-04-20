FactoryGirl.define do
  factory :search do
    account
    label { Faker::Company.buzzword }
  end
end
