require 'rails_helper'

RSpec.describe Organization, type: :model do
  let!(:organization) { create(:organization, :with_contact) }
  let(:contact) { organization.users.find_by(contact: true) }

  describe ".for" do
    let(:organization) { create(:organization) }
    it "looks up an organization by phone number" do
      expect(Organization.for(phone: organization.phone_number)).to eq(organization)
    end
  end

  describe "#send_message" do
    let(:organization) { create(:organization) }
    let(:user) { create(:user, organization: organization) }

    it "sends the sms message" do
      expect{
        organization.send_message(to: user.phone_number, body: "Test")
      }.to change{FakeMessaging.messages.count}.by(1)
    end
  end

  describe "#contact" do
    it "returns the contact user" do
      expect(organization.contact).to eq(contact)
    end
  end
end
