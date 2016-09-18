FactoryGirl.define do
  factory :rule do
    organization
    trigger { 'subscribe' }

    transient do
      format :text
    end

    actionable
  end
end
