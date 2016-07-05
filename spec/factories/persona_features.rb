FactoryGirl.define do
  factory :persona_feature do
    candidate_persona
    format { "document" }
    name { ["TB Test", "CPR Exam", "CNA License"].sample }

    trait :choice do
      format "choice"
      name "What is your availability?"
      properties { { choice_options: { 'a' => 'Live-in', 'b' => 'Hourly', 'c' => 'Both' } } }
    end
  end
end
