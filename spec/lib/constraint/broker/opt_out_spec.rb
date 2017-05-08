require 'rails_helper'

RSpec.describe Constraint::Broker::OptOut do
  let(:request) { ActionDispatch::Request.new({}) }
  let(:constraint) { Constraint::Broker::OptOut.new }
  let(:broker) { create(:broker) }

  before do
    allow(request).to receive(:request_parameters).and_return(parameters)
  end

  describe '#matches?' do
    context 'to a broker phone number' do
      context 'STOP as body' do
        let(:parameters) { { 'Body' => 'STOP', 'To' => broker.phone_number } }
        it 'is true' do
          expect(constraint.matches?(request)).to eq(true)
        end
      end

      context 'STOPALL as body' do
        let(:parameters) { { 'Body' => 'STOPALL', 'To' => broker.phone_number } }
        it 'is true' do
          expect(constraint.matches?(request)).to eq(true)
        end
      end

      context 'QUIT as body' do
        let(:parameters) { { 'Body' => 'QUIT', 'To' => broker.phone_number } }
        it 'is true' do
          expect(constraint.matches?(request)).to eq(true)
        end
      end

      context 'END as body' do
        let(:parameters) { { 'Body' => 'END', 'To' => broker.phone_number } }
        it 'is true' do
          expect(constraint.matches?(request)).to eq(true)
        end
      end

      context 'UNSUBSCRIBE as body' do
        let(:parameters) { { 'Body' => 'UNSUBSCRIBE', 'To' => broker.phone_number } }
        it 'is true' do
          expect(constraint.matches?(request)).to eq(true)
        end
      end

      context 'CANCEL as body' do
        let(:parameters) { { 'Body' => 'CANCEL', 'To' => broker.phone_number } }
        it 'is true' do
          expect(constraint.matches?(request)).to eq(true)
        end
      end

      context 'stop as body' do
        let(:parameters) { { 'Body' => 'stop', 'To' => broker.phone_number } }
        it 'is true' do
          expect(constraint.matches?(request)).to eq(true)
        end
      end

      context 'STOP in body' do
        context 'with whitespace' do
          let(:parameters) { { 'Body' => '    STOP ', 'To' => broker.phone_number } }

          it 'is true' do
            expect(constraint.matches?(request)).to eq(true)
          end
        end

        context 'with punctuation' do
          let(:parameters) { { 'Body' => '    STOP. ', 'To' => broker.phone_number } }

          it 'is true' do
            expect(constraint.matches?(request)).to eq(true)
          end
        end
      end
    end

    context 'to an organization phone number' do
      let(:organization) { create(:organization, :phone_number) }

      context 'STOP as body' do
        let(:parameters) { { 'Body' => 'STOP', 'To' => organization.phone_number } }
        it 'is false' do
          expect(constraint.matches?(request)).to eq(false)
        end
      end

      context 'STOPALL as body' do
        let(:parameters) { { 'Body' => 'STOPALL', 'To' => organization.phone_number } }
        it 'is false' do
          expect(constraint.matches?(request)).to eq(false)
        end
      end

      context 'QUIT as body' do
        let(:parameters) { { 'Body' => 'QUIT', 'To' => organization.phone_number } }
        it 'is false' do
          expect(constraint.matches?(request)).to eq(false)
        end
      end

      context 'END as body' do
        let(:parameters) { { 'Body' => 'END', 'To' => organization.phone_number } }
        it 'is false' do
          expect(constraint.matches?(request)).to eq(false)
        end
      end

      context 'UNSUBSCRIBE as body' do
        let(:parameters) { { 'Body' => 'UNSUBSCRIBE', 'To' => organization.phone_number } }
        it 'is false' do
          expect(constraint.matches?(request)).to eq(false)
        end
      end

      context 'CANCEL as body' do
        let(:parameters) { { 'Body' => 'CANCEL', 'To' => organization.phone_number } }
        it 'is false' do
          expect(constraint.matches?(request)).to eq(false)
        end
      end

      context 'stop as body' do
        let(:parameters) { { 'Body' => 'stop', 'To' => organization.phone_number } }
        it 'is false' do
          expect(constraint.matches?(request)).to eq(false)
        end
      end

      context 'STOP in body' do
        context 'with whitespace' do
          let(:parameters) { { 'Body' => '    STOP ', 'To' => organization.phone_number } }

          it 'is false' do
            expect(constraint.matches?(request)).to eq(false)
          end
        end

        context 'with punctuation' do
          let(:parameters) { { 'Body' => '    STOP. ', 'To' => organization.phone_number } }

          it 'is false' do
            expect(constraint.matches?(request)).to eq(false)
          end
        end
      end
    end

    context 'with additional text' do
      let(:parameters) { { 'Body' => 'STOP to do the limbo?', 'To' => broker.phone_number } }

      it 'is false' do
        expect(constraint.matches?(request)).to eq(false)
      end
    end

    context 'STOP not in body' do
      let(:parameters) { { 'Body' => 'Another body', 'To' => broker.phone_number } }

      it 'is false' do
        expect(constraint.matches?(request)).to eq(false)
      end
    end
  end
end
