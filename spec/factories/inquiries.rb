FactoryGirl.define do
  factory :inquiry do
    user_feature

    transient do
      user nil
    end

    before(:create) do |inquiry, evaluator|
      if evaluator.user
        inquiry.user_feature = create(:user_feature, user: evaluator.user)
      end
    end
  end
end
