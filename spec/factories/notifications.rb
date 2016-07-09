FactoryGirl.define do
  factory :notification do
    user
    template

    after(:create) do |notification|
      create(:message, notification: notification)
    end
  end
end
