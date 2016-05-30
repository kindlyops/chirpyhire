FactoryGirl.define do
  factory :feature do
    profile
    format { "document" }
    name { Faker::Lorem.sentence }
  end
end
