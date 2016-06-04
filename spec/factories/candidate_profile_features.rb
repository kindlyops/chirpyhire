FactoryGirl.define do
  factory :candidate_profile_feature do
    ideal_feature
    candidate_profile

    transient do
      user nil
    end

    before(:create) do |candidate_profile_feature, evaluator|
      if evaluator.user
        candidate_profile_feature.candidate_profile = create(:candidate_profile, user: evaluator.user)
      end
    end
  end
end
