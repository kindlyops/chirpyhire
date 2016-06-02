FactoryGirl.define do
  factory :inquiry do
    user_feature
    message

    transient do
      user nil
    end

    before(:create) do |inquiry, evaluator|
      if evaluator.user
        inquiry.message = create(:message, user: evaluator.user)
        inquiry.user_feature = create(:user_feature, user: evaluator.user)
      end
    end
  end
end
