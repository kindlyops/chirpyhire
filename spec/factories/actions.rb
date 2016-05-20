FactoryGirl.define do
  factory :action do
    organization

    trait :with_question do
      after(:create) do |action|
        create(:question, action: action)
      end
    end

    trait :with_notice do
      after(:create) do |action|
        create(:notice, action: action)
      end
    end
  end
end
