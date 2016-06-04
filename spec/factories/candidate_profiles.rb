FactoryGirl.define do
  factory :candidate_profile do
    ideal_profile
    candidate

    transient do
      user nil
    end

    before(:create) do |candidate_profile, evaluator|
      if evaluator.user
        candidate_profile.candidate = create(:candidate, user: evaluator.user)
      end
    end
  end
end
