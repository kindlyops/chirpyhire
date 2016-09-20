require 'rails_helper'

RSpec.describe AutomatonJob do
  let(:user) { create(:user) }

  describe '#perform' do
    it 'calls the Automaton' do
      expect(Automaton).to receive(:call).with(user, 'screen')
      AutomatonJob.perform_now(user, 'screen')
    end
  end
end
