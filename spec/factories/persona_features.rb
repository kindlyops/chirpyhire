FactoryGirl.define do
  factory :persona_feature do
    candidate_persona
    format { "document" }
    text { ["TB Test", "CPR Exam", "CNA License"].sample }
    category
    sequence(:priority) { |p| p }

    trait :choice do
      format "choice"
      text "What is your availability?"
      properties { { choice_options: { 'a' => 'Live-in', 'b' => 'Hourly', 'c' => 'Both' } } }
    end
  end
end
