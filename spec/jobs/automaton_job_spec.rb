require 'rails_helper'

RSpec.describe AutomatonJob do

  let(:user) { create(:user) }
  let(:trigger) { create(:trigger) }

  describe "#perform" do
    it "calls the Automaton" do
      expect(Automaton).to receive(:call).with(user, trigger)
      AutomatonJob.perform_now(user, trigger)
    end
  end
end
