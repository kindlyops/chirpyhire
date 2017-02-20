FactoryGirl.define do
  factory :ideal_candidate do
    organization

    before(:create) do |ideal_candidate|
      ideal_candidate.zipcodes_attributes = [{ value: '30342' }]
    end
  end
end
