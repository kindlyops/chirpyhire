require 'rails_helper'

RSpec.describe AutomatonJob do
  let(:user) { create(:user) }

  describe '#perform' do
    it 'calls the Automaton' do
      expect { AutomatonJob.perform_now(user, 'screen') }.to_not raise_error
    end
  end
end
