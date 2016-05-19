require 'rails_helper'

RSpec.describe Automaton do

  let(:user) { create(:user) }
  let(:trigger) { create(:trigger, event: :answer) }
  let(:observable) { create(:observable) }

  describe ".call" do
    it "creates an automaton" do
      expect(Automaton).to receive(:new).with(user, trigger).and_call_original
      Automaton.call(user, trigger)
    end
  end

  describe "#call" do
    let(:automaton) { Automaton.new(user, trigger) }

    context "with rules" do
      context "on the organization" do
        context "a collection rule for the trigger" do
          let(:trigger) { create(:trigger) }
          let!(:rule) { create(:rule, trigger: trigger, organization: user.organization) }

          it "is fired" do
            expect_any_instance_of(Rule).to receive(:perform).with(user)
            automaton.call
          end
        end

        context "a instance rule for the trigger" do
          let!(:rule) { create(:rule, trigger: trigger, organization: user.organization) }

          it "is fired" do
            expect_any_instance_of(Rule).to receive(:perform).with(user)
            automaton.call
          end
        end
      end
    end
  end
end
