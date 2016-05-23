require 'rails_helper'

RSpec.describe RuleDecorator do

  subject { RuleDecorator.new(rule) }

  describe "#state" do
    context "enabled" do
      let(:rule) { create(:rule) }

      it "is 'Enabled'" do
        expect(subject.state).to eq("Enabled")
      end
    end

    context "disabled" do
      let(:rule) { create(:rule, enabled: false) }
      it "is 'Disabled'" do
        expect(subject.state).to eq("Disabled")
      end
    end
  end

  describe "#state_class" do
    context "enabled" do
      let(:rule) { create(:rule) }

      it "is 'enabled'" do
        expect(subject.state_class).to eq("fa-circle enabled")
      end
    end

    context "disabled" do
      let(:rule) { create(:rule, enabled: false) }
      it "is 'disabled'" do
        expect(subject.state_class).to eq("fa-circle disabled")
      end
    end
  end
end
