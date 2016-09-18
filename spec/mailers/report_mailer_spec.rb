require 'rails_helper'

RSpec.describe ReportMailer do
  let!(:recipient) { create(:account, :with_subscription) }

  describe '#daily' do
    describe 'active accounts' do
      before do
        recipient.organization.subscription.update(state: 'active')
      end

      describe 'without activity' do
        it 'does not send an email' do
          expect do
            described_class.daily(Report::Daily.new(recipient)).deliver_now
          end.not_to change { described_class.deliveries.count }
        end
      end

      describe 'with activity' do
        before do
          create(:candidate, status: 'Qualified', user: create(:user, organization: recipient.organization))
        end

        it 'does send an email' do
          expect do
            described_class.daily(Report::Daily.new(recipient)).deliver_now
          end.to change { described_class.deliveries.count }.by(1)
        end
      end
    end

    describe 'trial accounts' do
      before do
        recipient.organization.subscription.update(state: 'trialing')
      end

      it 'does not send an email to the trialing accounts' do
        expect do
          described_class.daily(Report::Daily.new(recipient)).deliver_now
        end.not_to change { described_class.deliveries.count }
      end
    end
  end

  describe '#weekly' do
    describe 'active accounts' do
      before do
        recipient.organization.subscription.update(state: 'active')
      end

      it 'does send an email' do
        expect do
          described_class.daily(Report::Weekly.new(recipient)).deliver_now
        end.not_to change { described_class.deliveries.count }
      end
    end

    describe 'trial accounts' do
      before do
        recipient.organization.subscription.update(state: 'trialing')
      end

      it 'does not send an email to the trialing accounts' do
        expect do
          described_class.daily(Report::Weekly.new(recipient)).deliver_now
        end.not_to change { described_class.deliveries.count }
      end
    end
  end
end
