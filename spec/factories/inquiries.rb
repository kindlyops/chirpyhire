FactoryGirl.define do
  factory :inquiry do
    message
    lead
    question

    trait :stale do
      created_at { 60.days.ago }
    end
  end
end
