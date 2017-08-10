require 'rails_helper'

RSpec.describe CampaignContact::Activator do
  let(:campaign_contact) { create(:campaign_contact, state: :paused) }
  let(:contact) { campaign_contact.contact }
  let!(:campaign) { campaign_contact.campaign }

  subject  { CampaignContact::Activator.new(campaign_contact) }

  describe 'call' do
    context 'paused campaign contact' do
      before do
        campaign.update(last_paused_at: 1.day.ago)
      end

      context 'campaign is paused' do
        before do
          campaign.update(status: :paused)
        end

        it 'does not change the state of the campaign contact' do
          expect {
            subject.call
          }.not_to change { campaign_contact.reload.state }
        end
      end

      context 'campaign is active' do
        it 'does change the state of the campaign contact to active' do
          expect {
            subject.call
          }.to change { campaign_contact.reload.state }.from('paused').to('active')
        end

        context 'with a message created after the campaign was paused' do
          let(:conversation) { create(:conversation, contact: contact) }
          let!(:message) { create(:message) }

          before do
            message.update(conversation_part: create(:conversation_part, conversation: conversation))
          end

          context 'to the campaign_contact phone number' do
            before do
              message.update(to: campaign_contact.phone_number.phone_number)
            end

            context 'whose conversation part is not tied to a campaign' do
              it 'calls DeliveryAgent' do
                expect(DeliveryAgent).to receive(:call)

                subject.call
              end
            end
          end
        end
      end
    end
  end
end
