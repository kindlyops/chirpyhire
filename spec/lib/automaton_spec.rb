require 'rails_helper'

RSpec.describe Automaton do

  let(:user) { create(:user) }
  let(:trigger) { create(:question) }
  let(:event) { "answer" }

  describe ".call" do
    it "creates an automaton" do
      expect(Automaton).to receive(:new).with(user, trigger, event).and_call_original
      Automaton.call(user, trigger, event)
    end
  end

  describe "#call" do
    let(:automaton) { Automaton.new(user, trigger, event) }

    context "with rules" do
      context "on the organization" do
        context "a collection rule for the trigger" do
          let!(:rule) { create(:rule, event: event, trigger_type: trigger.class, organization: user.organization) }

          it "is fired" do
            expect_any_instance_of(Rule).to receive(:perform).with(user)
            automaton.call
          end
        end

        context "a instance rule for the trigger" do
          let!(:rule) { create(:rule, event: event, trigger: trigger, organization: user.organization) }

          it "is fired" do
            expect_any_instance_of(Rule).to receive(:perform).with(user)
            automaton.call
          end
        end

        context "with a rule not for the trigger" do
          let!(:rule) { create(:rule, event: event, trigger_type: "Candidate", organization: user.organization) }

          it "is not fired" do
            expect_any_instance_of(Rule).not_to receive(:perform)
            automaton.call
          end
        end
      end

      context "a collection rule for the trigger" do
        let!(:rule) { create(:rule, event: event, trigger_type: trigger.class) }

        it "is not fired" do
          expect_any_instance_of(Rule).not_to receive(:perform)
          automaton.call
        end
      end

      context "a instance rule for the trigger" do
        let!(:rule) { create(:rule, event: event, trigger: trigger) }

        it "is not fired" do
          expect_any_instance_of(Rule).not_to receive(:perform)
          automaton.call
        end
      end

      context "with a rule not for the trigger" do
        let!(:rule) { create(:rule, event: event, trigger_type: "Candidate") }

        it "is not fired" do
          expect_any_instance_of(Rule).not_to receive(:perform)
          automaton.call
        end
      end
    end
  end
end
