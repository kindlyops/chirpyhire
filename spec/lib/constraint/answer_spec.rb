require 'rails_helper'

RSpec.describe Constraint::Answer do
  let(:request) { ActionDispatch::Request.new({}) }
  let(:constraint) { Constraint::Answer.new }
  let(:organization) { create(:organization) }

  before(:each) do
    allow(request).to receive(:request_parameters).and_return(parameters)
  end

  describe '#matches?' do
    context 'with person present' do
      let(:person) { create(:person) }
      let(:parameters) { { 'From' => person.phone_number, 'To' => organization.phone_number } }

      context 'with subscriber present' do
        let!(:subscriber) { create(:subscriber, person: person, organization: organization) }

        context 'tied to the candidacy' do
          before do
            person.candidacy.update(subscriber: subscriber)
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

        context 'candidacy tied to another subscriber' do
          before do
            person.candidacy.update(subscriber: create(:subscriber, person: person))
          end

          it 'is false' do
            expect(constraint.matches?(request)).to eq(false)
          end
        end

        context 'candidacy not tied to a subscriber' do
          it 'is false' do
            expect(constraint.matches?(request)).to eq(false)
          end
        end
      end

      context 'without subscriber present' do
        it 'is false' do
          expect(constraint.matches?(request)).to eq(false)
        end
      end
    end

    context 'without subscriber present' do
      let(:parameters) { { 'From' => '+14041111111', 'To' => organization.phone_number } }

      it 'is false' do
        expect(constraint.matches?(request)).to eq(false)
      end
    end
  end
end
