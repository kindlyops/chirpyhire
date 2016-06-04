FactoryGirl.define do
  factory :ideal_feature do
    ideal_profile
    format { "document" }
    name { ["TB Test", "CPR Exam", "CNA License"].sample }
  end
end
