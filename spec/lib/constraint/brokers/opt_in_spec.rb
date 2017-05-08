require 'rails_helper'

RSpec.describe Constraint::Brokers::OptIn do
  let(:request) { ActionDispatch::Request.new({}) }
  let(:constraint) { Constraint::Brokers::OptIn.new }
  let!(:broker) { create(:broker) }

  before do
    allow(request).to receive(:request_parameters).and_return(parameters)
  end

  describe '#matches?' do
    context 'YES as body' do
      let(:parameters) { { 'Body' => 'YES', 'To' => broker.phone_number } }
      it 'is false' do
        expect(constraint.matches?(request)).to eq(false)
      end
    end

    context 'START not in body' do
      let(:parameters) { { 'Body' => 'Another body', 'To' => broker.phone_number } }

      it 'is false' do
        expect(constraint.matches?(request)).to eq(false)
      end
    end

    context 'to a broker phone number' do
      context 'START as body' do
        let(:parameters) { { 'Body' => 'START', 'To' => broker.phone_number } }
        it 'is true' do
          expect(constraint.matches?(request)).to eq(true)
        end
      end

      context 'START. as body' do
        let(:parameters) { { 'Body' => 'START.', 'To' => broker.phone_number } }
        it 'is true' do
          expect(constraint.matches?(request)).to eq(true)
        end
      end

      context 'start as body' do
        let(:parameters) { { 'Body' => 'start', 'To' => broker.phone_number } }
        it 'is true' do
          expect(constraint.matches?(request)).to eq(true)
        end
      end

      context 'START in body' do
        context 'with whitespace' do
          let(:parameters) { { 'Body' => '    START ', 'To' => broker.phone_number } }

          it 'is true' do
            expect(constraint.matches?(request)).to eq(true)
          end
        end

        context 'with additional text' do
          let(:parameters) { { 'Body' => 'START to do the limbo?', 'To' => broker.phone_number } }

          it 'is true' do
            expect(constraint.matches?(request)).to eq(true)
          end
        end
      end
    end

    context 'not to a broker phone number' do
      let!(:organization) { create(:organization, :phone_number) }

      context 'START as body' do
        let(:parameters) { { 'Body' => 'START', 'To' => organization.phone_number } }
        it 'is false' do
          expect(constraint.matches?(request)).to eq(false)
        end
      end

      context 'START. as body' do
        let(:parameters) { { 'Body' => 'START.', 'To' => organization.phone_number } }
        it 'is false' do
          expect(constraint.matches?(request)).to eq(false)
        end
      end

      context 'start as body' do
        let(:parameters) { { 'Body' => 'start', 'To' => organization.phone_number } }
        it 'is false' do
          expect(constraint.matches?(request)).to eq(false)
        end
      end

      context 'START in body' do
        context 'with whitespace' do
          let(:parameters) { { 'Body' => '    START ', 'To' => organization.phone_number } }

          it 'is false' do
            expect(constraint.matches?(request)).to eq(false)
          end
        end

        context 'with additional text' do
          let(:parameters) { { 'Body' => 'START to do the limbo?', 'To' => organization.phone_number } }

          it 'is false' do
            expect(constraint.matches?(request)).to eq(false)
          end
        end
      end
    end
  end
end
