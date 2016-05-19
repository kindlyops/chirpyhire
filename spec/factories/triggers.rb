FactoryGirl.define do
  factory :trigger do
    organization
    observable_type "Candidate"
    event :subscribe

    trait :answer do
      association :observable, factory: :question
      event :answer
    end
  end
end
