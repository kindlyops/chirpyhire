FactoryGirl.define do
  factory :search do
    account
    title { Faker::Company.buzzword }

    trait :with_search_question do
      after(:create) do |search|
        create(:search_question, search: search)
      end
    end

    trait :with_search_lead do
      after(:create) do |search|
        create(:search_lead, search: search)
      end
    end
  end
end
