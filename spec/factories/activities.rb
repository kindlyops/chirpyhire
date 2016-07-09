FactoryGirl.define do
  factory :activity do
    association :trackable, factory: :notification
    association :owner, factory: :user
    key { 'notification.create' }
  end
end
