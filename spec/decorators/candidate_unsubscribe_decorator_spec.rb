require 'rails_helper'

RSpec.describe CandidateUnsubscribeDecorator do
  let(:model) { create(:candidate) }
  let(:candidate) { CandidateUnsubscribeDecorator.new(model) }
  let(:user) { candidate.user }
  let(:organization) { candidate.organization }

  describe "#user" do
    it "is decorated" do
      expect(user).to be_decorated_with UserDecorator
    end
  end

  describe "#color" do
    it "is danger" do
      expect(candidate.color).to eq("danger")
    end
  end

  describe "#body" do
    it "is an unsubscribe message" do
      expect(candidate.body).to eq("#{user.from_short} is no longer interested in #{organization.name}.")
    end
  end

  describe "#icon_class" do
    it "is the subscribe hand" do
      expect(candidate.icon_class).to eq("fa-hand-paper-o")
    end
  end

  describe "#subtitle" do
    it "is the unsubscribe subtitle" do
      expect(candidate.subtitle).to eq("#{user.from_short} has unsubscribed.")
    end
  end

  describe "#attachments" do
    it "is an empty array" do
      expect(candidate.attachments).to eq([])
    end
  end
end
