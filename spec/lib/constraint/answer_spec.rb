require 'rails_helper'

RSpec.describe Constraint::Answer do
  let(:request) { ActionDispatch::Request.new({}) }
  let(:constraint) { Constraint::Answer.new }
  let(:organization) { create(:organization) }
  let(:team) { create(:team, :phone_number, organization: organization) }

  before do
    allow(request).to receive(:request_parameters).and_return(parameters)
  end

  describe '#matches?' do
    context 'with person present' do
      let(:person) { create(:person, :with_candidacy) }
      let(:parameters) { { 'From' => person.phone_number, 'To' => team.phone_number } }

      context 'with contact present' do
        let!(:contact) { create(:contact, person: person, organization: organization) }

        context 'tied to the candidacy' do
          before do
            person.candidacy.update(contact: contact)
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

            context 'on the team' do
              before do
                contact.update(team: team)
              end

              it 'is true' do
                expect(constraint.matches?(request)).to eq(true)
              end
            end

            context 'not on the team' do
              it 'is false' do
                expect(constraint.matches?(request)).to eq(false)
              end
            end
          end
        end

        context 'candidacy tied to another contact' do
          before do
            person.candidacy.update(contact: create(:contact, person: person))
          end

          it 'is false' do
            expect(constraint.matches?(request)).to eq(false)
          end
        end

        context 'candidacy not tied to a contact' do
          it 'is false' do
            expect(constraint.matches?(request)).to eq(false)
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
      let(:parameters) { { 'From' => '+14041111111', 'To' => team.phone_number } }

      it 'is false' do
        expect(constraint.matches?(request)).to eq(false)
      end
    end
  end
end
