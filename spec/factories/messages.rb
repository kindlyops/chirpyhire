FactoryGirl.define do
  factory :message do
    sid { Faker::Internet.password(34) }
    account_sid { Faker::Internet.password(34) }
    from { Phony.normalize(Faker::PhoneNumber.phone_number) }
    to { Phony.normalize(Faker::PhoneNumber.phone_number) }
    body ""
    status "received"
    direction "inbound"
  end
end
