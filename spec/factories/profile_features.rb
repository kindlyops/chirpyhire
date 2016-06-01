FactoryGirl.define do
  factory :profile_feature do
    profile
    format { "document" }
    name { ["TB Test", "CPR Exam", "CNA License"].sample }
  end
end
