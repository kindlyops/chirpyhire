require 'rails_helper'

RSpec.describe Action, type: :model do
  let(:action) { create(:action) }
  let(:actionable) { action.actionable }
  let(:template) { actionable.template }
  let(:user) { create(:user) }

  let(:messaging) { FakeMessaging.new("foo", "bar") }
  let(:from) { Faker::PhoneNumber.cell_phone }
  let(:to) { Faker::PhoneNumber.cell_phone }
  let(:body) { Faker::Lorem.word }
  let(:message) { messaging.create(from: from, to: to, body: body) }

  describe "#perform" do
    before(:each) do
      allow(actionable).to receive(:perform).and_return(message)
    end

    context "actionable question" do
      it "creates an inquiry" do
        expect {
          action.perform(user)
        }.to change{actionable.inquiries.count}.by(1)
      end
    end

    context "actionable notice" do
      let(:action) { create(:action, :with_notice) }

      it "creates a notification" do
        expect {
          action.perform(user)
        }.to change{actionable.notifications.count}.by(1)
      end
    end
  end

  describe "description" do
    it "is the name of the template" do
      expect(action.description).to eq(template.name)
    end
  end
end
