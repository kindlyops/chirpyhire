FactoryGirl.define do
  factory :answer do
    question
    lead
    message
    body { Faker::Company.buzzword }

    trait :stale do
      created_at { 60.days.ago }
    end
  end
end
