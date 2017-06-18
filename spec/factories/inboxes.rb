FactoryGirl.define do
  factory :inbox do
    association :inboxable, factory: :account
  end
end
