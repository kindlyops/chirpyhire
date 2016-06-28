require 'rails_helper'

RSpec.describe NotificationCreateDecorator do
  let(:model) { create(:notification) }
  let(:notification) { NotificationCreateDecorator.new(model) }
  let(:recipient) { notification.recipient }

  describe "#color" do
    it "is info" do
      expect(notification.color).to eq("info")
    end
  end

  describe "#icon_class" do
    it "is fa-info" do
      expect(notification.icon_class).to eq("fa-info")
    end
  end

  describe "#subtitle" do
    it "is a Notification Create subtitle" do
      expect(notification.subtitle).to eq("Notification sent to #{recipient.decorate.to_short}")
    end
  end
end
