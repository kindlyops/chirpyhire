require 'rails_helper'

RSpec.describe ReportMailer do
  let!(:recipient) { create(:account, :with_subscription) }

  describe '#daily' do
    describe 'active accounts' do
      before(:each) do
        recipient.organization.subscription.update(state: 'active')
      end

      describe 'without activity' do
        it 'does not send an email' do
          expect {
            ReportMailer.send_report(Report::Daily.new(recipient)).deliver_now
          }.not_to change { ReportMailer.deliveries.count }
        end
      end

      describe 'with activity' do
        before(:each) do
          create(:candidate, stage: recipient.organization.qualified_stage, user: create(:user, organization: recipient.organization))
        end

        it 'does send an email' do
          expect {
            ReportMailer.send_report(Report::Daily.new(recipient)).deliver_now
          }.to change { ReportMailer.deliveries.count }.by(1)
        end
      end
    end

    describe 'trial accounts' do
      before(:each) do
        recipient.organization.subscription.update(state: 'trialing')
      end

      it 'does not send an email to the trialing accounts' do
        expect {
          ReportMailer.send_report(Report::Daily.new(recipient)).deliver_now
        }.not_to change { ReportMailer.deliveries.count }
      end
    end
  end

  describe '#weekly' do
    describe 'active accounts' do
      before(:each) do
        recipient.organization.subscription.update(state: 'active')
      end

      it 'does send an email' do
        expect {
          ReportMailer.send_report(Report::Weekly.new(recipient)).deliver_now
        }.to change { ReportMailer.deliveries.count }
      end
    end

    describe 'trial accounts' do
      before(:each) do
        recipient.organization.subscription.update(state: 'trialing')
      end

      it 'does not send an email to the trialing accounts' do
        expect {
          ReportMailer.send_report(Report::Weekly.new(recipient)).deliver_now
        }.not_to change { ReportMailer.deliveries.count }
      end
    end
  end
end
