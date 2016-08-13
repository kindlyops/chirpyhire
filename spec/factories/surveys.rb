FactoryGirl.define do
  factory :survey do
    organization

    before(:create) do |survey|
      survey.welcome = create(:template, organization: survey.organization)
      survey.bad_fit = create(:template, organization: survey.organization)
      survey.thank_you = create(:template, organization: survey.organization)
    end

    trait :with_questions do
      after(:create) do |survey|
        create_list(:question, 2, survey: survey)
      end
    end
  end
end
