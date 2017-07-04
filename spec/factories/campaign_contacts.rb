FactoryGirl.define do
  factory :campaign_contact do
    campaign
    contact
    phone_number

    trait :active do
      state { :active }
    end
  end
end
