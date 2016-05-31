require 'rails_helper'

RSpec.describe Automaton do

  let(:user) { create(:user) }
  let(:organization) { user.organization }

  describe ".call" do
    it "creates an automaton" do
      expect(Automaton).to receive(:new).with(user, "screen").and_call_original
      Automaton.call(user, "screen")
    end
  end

  describe "#call" do
    let(:automaton) { Automaton.new(user, "screen") }

    context "with rules" do
      context "on the organization" do
        let!(:rule) { create(:rule, trigger: "screen", organization: organization) }

        it "is fired" do
          expect_any_instance_of(Rule).to receive(:perform).with(user)
          automaton.call
        end
      end
    end
  end
end
