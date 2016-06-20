FactoryGirl.define do
  factory :candidate_feature do
    candidate
    before(:create) do |candidate_feature|
      candidate_feature.ideal_feature = create(:ideal_feature, ideal_profile: candidate_feature.candidate.ideal_profile)
    end

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
