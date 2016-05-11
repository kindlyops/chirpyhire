require 'rails_helper'

RSpec.feature "Referral Submission" do
  let(:organization) { create(:organization, :with_successful_phone) }

  before(:each) do
    Cavy.phones = [organization.phone_number, phone_number]
  end

  context "as a referrer" do
  end

  context "not as a referrer" do
    let(:phone_number) { "+14041111111" }
    let(:vcard) do
      Struct.new(:from, :to, :body, :sid).new(phone_number, organization.phone_number, "Foo", "Bar")
    end

    it "displays a nice error text message to the user" do
      message(phone_number, vcard)
      expect(conversation.thread).to include("Sorry I didn't understand that. Have a great day!")
    end
  end
end
