FactoryGirl.define do
  factory :notification do
    user
    template

    after(:create) do |notification|
      create(:message, messageable: notification)
    end
  end
end
