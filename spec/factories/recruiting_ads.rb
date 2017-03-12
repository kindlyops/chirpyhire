FactoryGirl.define do
  factory :recruiting_ad do
    organization
    body { Faker::Lorem.paragraph }
  end
end
