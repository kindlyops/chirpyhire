require 'rails_helper'

RSpec.describe IdealCandidate do
  subject { create(:ideal_candidate) }

  describe '#zipcode?' do
    context 'including zipcode' do
      let(:zipcode) { '30342' }
      it 'is true' do
        expect(subject.zipcode?(zipcode)).to eq(true)
      end
    end

    context 'not including zipcode' do
      let(:zipcode) { '22902' }

      it 'is false' do
        expect(subject.zipcode?(zipcode)).to eq(false)
      end
    end
  end
end
