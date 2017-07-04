require 'rails_helper'

RSpec.describe DeliveryAgent do
  let(:organization) { create(:organization, :phone_number) }
  let(:team) { create(:team, organization: organization) }
  let(:inbox) { team.create_inbox }
  let(:phone_number) { organization.phone_numbers.first }
  let(:contact) { create(:contact, organization: organization) }

  describe 'call' do
    subject { DeliveryAgent.new(message) }

    context 'with assignment rules' do
      context 'assignment rule for phone number' do
        let!(:rule) { create(:assignment_rule, organization: organization, phone_number: phone_number, inbox: inbox) }
        let!(:conversation) { IceBreaker.call(contact, phone_number) }
        let!(:message) { create(:message, to: phone_number.phone_number, conversation: conversation) }

        it 'calls InboxDeliveryAgent' do
          expect(InboxDeliveryAgent).to receive(:call).with(inbox, message)

          subject.call
        end

        context 'and the assignment rule has been deleted' do
          before do
            rule.destroy
          end

          it 'does not call InboxDeliveryAgent' do
            expect(InboxDeliveryAgent).not_to receive(:call)

            subject.call
          end
        end
      end
    end

    context 'without assignment rules' do
      let!(:message) { create(:message, to: phone_number.phone_number) }

      it 'does not call InboxDeliveryAgent' do
        expect(InboxDeliveryAgent).not_to receive(:call)

        subject.call
      end
    end
  end
end
