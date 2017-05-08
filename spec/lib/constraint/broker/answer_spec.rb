require 'rails_helper'

RSpec.describe Constraint::Broker::Answer do
  let(:request) { ActionDispatch::Request.new({}) }
  let(:constraint) { Constraint::Broker::Answer.new }
  let(:broker) { create(:broker, :phone_number) }

  before do
    allow(request).to receive(:request_parameters).and_return(parameters)
  end

  describe '#matches?' do
    context 'with person present' do
      let(:person) { create(:person, :with_candidacy) }
      let(:parameters) { { 'From' => person.phone_number, 'To' => broker.phone_number } }

      context 'with broker_contact present' do
        let!(:broker_contact) { create(:broker_contact, person: person, broker: broker) }

        context 'tied to the candidacy' do
          before do
            person.candidacy.update(broker_contact: broker_contact)
          end

          context 'without inquiry' do
            it 'is false' do
              expect(constraint.matches?(request)).to eq(false)
            end
          end

          context 'with inquiry' do
            before do
              person.candidacy.update(inquiry: :experience)
            end

            it 'is true' do
              expect(constraint.matches?(request)).to eq(true)
            end
          end
        end

        context 'candidacy tied to another broker_contact' do
          before do
            person.candidacy.update(broker_contact: create(:broker_contact, person: person))
          end

          it 'is false' do
            expect(constraint.matches?(request)).to eq(false)
          end
        end

        context 'candidacy not tied to a broker_contact' do
          it 'is false' do
            expect(constraint.matches?(request)).to eq(false)
          end
        end
      end

      context 'without broker_contact present' do
        it 'is false' do
          expect(constraint.matches?(request)).to eq(false)
        end
      end
    end

    context 'without person present' do
      let(:parameters) { { 'From' => '+14041111111', 'To' => broker.phone_number } }

      it 'is false' do
        expect(constraint.matches?(request)).to eq(false)
      end
    end
  end
end
