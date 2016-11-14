require 'rails_helper'

RSpec.describe Constraint::OptIn do
  let(:request) { ActionDispatch::Request.new({}) }
  let(:constraint) { Constraint::OptIn.new }
  let!(:organization) { create(:organization) }

  before(:each) do
    allow(request).to receive(:request_parameters).and_return(parameters)
  end

  describe '#matches?' do
    context 'START as body' do
      let(:parameters) { { 'Body' => 'START' } }
      it 'is true' do
        expect(constraint.matches?(request)).to eq(true)
      end
    end

    context 'START. as body' do
      let(:parameters) { { 'Body' => 'START.' } }
      it 'is true' do
        expect(constraint.matches?(request)).to eq(true)
      end
    end

    context 'YES as body' do
      let(:parameters) { { 'Body' => 'YES' } }
      it 'is false' do
        expect(constraint.matches?(request)).to eq(false)
      end
    end

    context 'start as body' do
      let(:parameters) { { 'Body' => 'start' } }
      it 'is true' do
        expect(constraint.matches?(request)).to eq(true)
      end
    end

    context 'START in body' do
      context 'with whitespace' do
        let(:parameters) { { 'Body' => '    START ' } }

        it 'is true' do
          expect(constraint.matches?(request)).to eq(true)
        end
      end

      context 'with additional text' do
        let(:parameters) { { 'Body' => 'START to do the limbo?' } }

        it 'is true' do
          expect(constraint.matches?(request)).to eq(true)
        end
      end

      context 'as a candidate already' do
        let!(:user) { create(:user, :with_candidate, organization: organization) }
        let(:parameters) { { 'Body' => 'START to do the limbo?', 'To' => organization.phone_number, 'From' => user.phone_number } }
        it 'is false' do
          expect(constraint.matches?(request)).to eq(false)
        end
      end
    end

    context 'START not in body' do
      let(:parameters) { { 'Body' => 'Another body' } }

      it 'is false' do
        expect(constraint.matches?(request)).to eq(false)
      end
    end
  end
end
