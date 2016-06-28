FactoryGirl.define do
  factory :inquiry do
    candidate_feature
    user

    after(:create) do |inquiry|
      create(:message, messageable: inquiry)
    end
  end
end
