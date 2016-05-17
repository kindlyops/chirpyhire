require 'rails_helper'

RSpec.describe Automaton do

  let(:user) { create(:user) }
  let(:observable) { create(:question) }
  let(:event) { "answer" }

  describe ".call" do
    it "creates an automaton" do
      expect(Automaton).to receive(:new).with(user, observable, event).and_call_original
      Automaton.call(user, observable, event)
    end
  end

  describe "#call" do
    let(:automaton) { Automaton.new(user, observable, event) }

    context "with triggers" do
      context "on the organization" do
        context "a collection trigger for the observable" do
          let!(:trigger) { create(:trigger, event: event, observable_type: observable.class, organization: user.organization) }

          it "is fired" do
            expect_any_instance_of(Trigger).to receive(:fire).with(user)
            automaton.call
          end
        end

        context "a instance trigger for the observable" do
          let!(:trigger) { create(:trigger, event: event, observable: observable, organization: user.organization) }

          it "is fired" do
            expect_any_instance_of(Trigger).to receive(:fire).with(user)
            automaton.call
          end
        end

        context "with a trigger not for the observable" do
          let!(:trigger) { create(:trigger, event: event, observable_type: "Candidate", organization: user.organization) }

          it "is not fired" do
            expect_any_instance_of(Trigger).not_to receive(:fire)
            automaton.call
          end
        end
      end

      context "a collection trigger for the observable" do
        let!(:trigger) { create(:trigger, event: event, observable_type: observable.class) }

        it "is not fired" do
          expect_any_instance_of(Trigger).not_to receive(:fire)
          automaton.call
        end
      end

      context "a instance trigger for the observable" do
        let!(:trigger) { create(:trigger, event: event, observable: observable) }

        it "is not fired" do
          expect_any_instance_of(Trigger).not_to receive(:fire)
          automaton.call
        end
      end

      context "with a trigger not for the observable" do
        let!(:trigger) { create(:trigger, event: event, observable_type: "Candidate") }

        it "is not fired" do
          expect_any_instance_of(Trigger).not_to receive(:fire)
          automaton.call
        end
      end
    end
  end
end
