require 'rails_helper'

RSpec.describe Constraint::OptOut do
  let(:request) { ActionDispatch::Request.new({}) }
  let(:constraint) { Constraint::OptOut.new }

  before do
    allow(request).to receive(:request_parameters).and_return(parameters)
  end

  describe '#matches?' do
    context 'STOP as body' do
      let(:parameters) { { 'Body' => 'STOP' } }
      it 'is true' do
        expect(constraint.matches?(request)).to eq(true)
      end
    end

    context 'STOPALL as body' do
      let(:parameters) { { 'Body' => 'STOPALL' } }
      it 'is true' do
        expect(constraint.matches?(request)).to eq(true)
      end
    end

    context 'QUIT as body' do
      let(:parameters) { { 'Body' => 'QUIT' } }
      it 'is true' do
        expect(constraint.matches?(request)).to eq(true)
      end
    end

    context 'END as body' do
      let(:parameters) { { 'Body' => 'END' } }
      it 'is true' do
        expect(constraint.matches?(request)).to eq(true)
      end
    end

    context 'UNSUBSCRIBE as body' do
      let(:parameters) { { 'Body' => 'UNSUBSCRIBE' } }
      it 'is true' do
        expect(constraint.matches?(request)).to eq(true)
      end
    end

    context 'CANCEL as body' do
      let(:parameters) { { 'Body' => 'CANCEL' } }
      it 'is true' do
        expect(constraint.matches?(request)).to eq(true)
      end
    end

    context 'stop as body' do
      let(:parameters) { { 'Body' => 'stop' } }
      it 'is true' do
        expect(constraint.matches?(request)).to eq(true)
      end
    end

    context 'STOP in body' do
      context 'with whitespace' do
        let(:parameters) { { 'Body' => '    STOP ' } }

        it 'is true' do
          expect(constraint.matches?(request)).to eq(true)
        end
      end

      context 'with punctuation' do
        let(:parameters) { { 'Body' => '    STOP. ' } }

        it 'is true' do
          expect(constraint.matches?(request)).to eq(true)
        end
      end

      context 'with additional text' do
        let(:parameters) { { 'Body' => 'STOP to do the limbo?' } }

        it 'is false' do
          expect(constraint.matches?(request)).to eq(false)
        end
      end
    end

    context 'STOP not in body' do
      let(:parameters) { { 'Body' => 'Another body' } }

      it 'is false' do
        expect(constraint.matches?(request)).to eq(false)
      end
    end
  end
end
