FactoryGirl.define do
  factory :broker_contact do
    association :person, :with_broker_candidacy
    broker
  end
end
