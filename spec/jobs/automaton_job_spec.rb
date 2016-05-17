require 'rails_helper'

RSpec.describe AutomatonJob do

  let(:user) { create(:user) }
  let(:observable) { create(:question) }
  let(:event) { "answer" }

  describe "#perform" do
    it "calls the Automaton" do
      expect(Automaton).to receive(:call).with(user, observable, event)
      AutomatonJob.perform_now(user, observable, event)
    end
  end
end
