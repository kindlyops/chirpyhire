FactoryGirl.define do
  factory :profile_feature do
    profile
    format { "document" }
    name { Faker::Lorem.sentence }
  end
end
