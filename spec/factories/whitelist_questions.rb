FactoryGirl.define do
  factory :whitelist_question do
    survey
    text { Faker::Lorem.sentence }
    type 'WhitelistQuestion'
    sequence(:priority)
    sequence(:label) { |n| "label#{n}" }
    
    whitelist_question_options_attributes { [attributes_for(:whitelist_question_option)] }
  end
end
