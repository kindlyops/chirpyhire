require 'rails_helper'

RSpec.describe Constraint::Answer do
  let(:request) { ActionDispatch::Request.new({}) }
  let(:constraint) { Constraint::Answer.new }
  let(:organization) { create(:organization, :phone_number) }
  let!(:phone_number) { organization.phone_numbers.first.phone_number }

  before do
    allow(request).to receive(:request_parameters).and_return(parameters)
  end

  describe '#matches?' do
    context 'with person present' do
      let(:person) { create(:person) }
      let(:parameters) { { 'From' => person.phone_number, 'To' => phone_number } }

      context 'with contact present' do
        let!(:contact) { create(:contact, person: person, organization: organization) }

        context 'without inquiry' do
          it 'is false' do
            expect(constraint.matches?(request)).to eq(false)
          end
        end

        context 'with inquiry' do
          before do
            contact.contact_candidacy.update(inquiry: :experience)
          end

          it 'is true' do
            expect(constraint.matches?(request)).to eq(true)
          end
        end
      end

      context 'without contact present' do
        it 'is false' do
          expect(constraint.matches?(request)).to eq(false)
        end
      end
    end

    context 'without person present' do
      let(:parameters) { { 'From' => '+14041111111', 'To' => phone_number } }

      it 'is false' do
        expect(constraint.matches?(request)).to eq(false)
      end
    end
  end
end
