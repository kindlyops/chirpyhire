FactoryGirl.define do
  factory :broker_contact do
    association :person, :with_candidacy
    broker
  end
end
