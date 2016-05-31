FactoryGirl.define do
  factory :inquiry do
    candidate_feature
    message

    transient do
      user nil
    end

    before(:create) do |inquiry, evaluator|
      if evaluator.user
        inquiry.message = create(:message, user: evaluator.user)
        candidate = create(:candidate, user: evaluator.user)
        inquiry.candidate_feature = create(:candidate_feature, candidate: candidate)
      end
    end
  end
end
