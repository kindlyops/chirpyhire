FactoryGirl.define do
  factory :zipcode_question_option do
    text { ['30342', '30305', '30002',
            '30003', '30004', '30005',
            '30006', '30007', '30008'].sample }
  end
end
