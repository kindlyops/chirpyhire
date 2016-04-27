FactoryGirl.define do
  factory :job do
    account
    title { Faker::Company.buzzword }

    trait :with_job_question do
      after(:create) do |job|
        create(:job_question, job: job)
      end
    end

    trait :with_job_candidate do
      after(:create) do |job|
        create(:job_candidate, job: job)
      end
    end
  end
end
