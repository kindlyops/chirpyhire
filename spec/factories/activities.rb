FactoryGirl.define do
  factory :activity do
    trackable_type 'Candidate'
    key 'Candidate.update'
    properties { { status: 'Potential' } }
  end
end
