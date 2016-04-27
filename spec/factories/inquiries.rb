FactoryGirl.define do
  factory :inquiry do
    message
    candidate
    question

    trait :stale do
      created_at { 3.days.ago }
    end
  end
end
