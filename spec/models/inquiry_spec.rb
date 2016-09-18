require 'rails_helper'

RSpec.describe Inquiry do
  describe '#unanswered?' do
    context 'with answer' do
      let(:inquiry) { create(:inquiry, :with_answer) }

      it 'is false' do
        expect(inquiry.unanswered?).to eq(false)
      end
    end

    context 'without answer' do
      let(:inquiry) { create(:inquiry) }

      it 'is true' do
        expect(inquiry.unanswered?).to eq(true)
      end
    end
  end
end
