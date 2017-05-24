FactoryGirl.define do
  factory :recruiting_ad do
    team
    body { Faker::Lorem.paragraph }
  end
end
