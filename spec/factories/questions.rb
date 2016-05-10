FactoryGirl.define do
  factory :question do
    template

    trait :with_inquiry do
      after(:create) do |question|
        create(:inquiry, question: question)
      end
    end
  end
end
