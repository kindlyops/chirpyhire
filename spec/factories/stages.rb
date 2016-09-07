FactoryGirl.define do
  factory :stage do
    organization
    name ["Bad Fit", "Qualified", "Hired", "Potential", "Interviewed"].sample
    sequence(:order)
  end
end
