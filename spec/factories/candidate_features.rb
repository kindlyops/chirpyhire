FactoryGirl.define do
  factory :candidate_feature do
    ideal_feature
    candidate

    transient do
      user nil
    end

    before(:create) do |candidate_feature, evaluator|
      if evaluator.user
        candidate_feature.candidate = create(:candidate, user: evaluator.user)
      end
    end
  end
end
