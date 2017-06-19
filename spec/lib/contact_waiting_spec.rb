require 'rails_helper'

RSpec.describe ContactWaiting do
  let(:team) { create(:team, :inbox, :account) }
  let(:conversation) { create(:conversation, inbox: team.inbox) }
  let(:read_receipt) { create(:read_receipt, conversation: conversation) }

  subject { ContactWaiting.new(conversation, read_receipt) }

  describe '#call' do
    context 'read_receipt is read' do
      before do
        read_receipt.update(read_at: Time.current)
      end

      it 'does not send an email to the conversation account' do
        expect {
          subject.call
        }.not_to have_enqueued_job(ActionMailer::DeliveryJob)
      end
    end

    context 'read_receipt is not read' do
      context 'and a more recent read_receipt is not read' do
        before do
          create(:read_receipt, conversation: conversation, created_at: 5.minutes.from_now)
        end

        it 'does not send an email to the conversation account' do
          expect {
            subject.call
          }.not_to have_enqueued_job(ActionMailer::DeliveryJob)
        end
      end

      context 'and a past read_receipt is not read' do
        before do
          create(:read_receipt, conversation: conversation, created_at: 10.days.ago)
        end

        it 'sends an email to the conversation account' do
          expect {
            subject.call
          }.to have_enqueued_job(ActionMailer::DeliveryJob)
            .with { |mailer, mailer_method, *_args|
                 expect(mailer).to eq('NotificationMailer')
                 expect(mailer_method).to eq('contact_waiting')
               }.exactly(:once)
        end
      end

      it 'sends an email to the conversation account' do
        expect {
          subject.call
        }.to have_enqueued_job(ActionMailer::DeliveryJob)
          .with { |mailer, mailer_method, *_args|
               expect(mailer).to eq('NotificationMailer')
               expect(mailer_method).to eq('contact_waiting')
             }.exactly(:once)
      end
    end
  end
end
