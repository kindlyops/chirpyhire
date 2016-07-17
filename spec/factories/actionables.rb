FactoryGirl.define do
  factory :actionable do
    type { Actionable::TYPES.sample }
  end
end
