FactoryGirl.define do
  factory :persona_feature do
    candidate_persona
    format { "document" }
    name { ["TB Test", "CPR Exam", "CNA License"].sample }
  end
end
