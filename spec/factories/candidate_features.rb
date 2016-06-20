FactoryGirl.define do
  factory :candidate_feature do
    candidate
    before(:create) do |candidate_feature|
      candidate_feature.persona_feature = create(:persona_feature, candidate_persona: candidate_feature.candidate.candidate_persona)
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
