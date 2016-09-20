require 'rails_helper'

RSpec.describe Reporter do
  let(:count) { rand(1..5) }
  let!(:recipients) { create_list(:account, count) }
  let(:reporter) { Reporter.new(Account, Report::Daily, :daily) }

  describe 'report' do
    context 'with an inactive account' do
      before(:each) do
        recipients.sample.update(invitation_token: Faker::Lorem.sentence)
      end

      it 'does not send an email to the inactive accounts' do
        delivery = double
        expect(delivery).to receive(:deliver_now).exactly(count - 1).times
        allow(ReportMailer).to receive(:daily).and_return(delivery).exactly(count - 1).times

        reporter.report
      end
    end

    it 'sends an email to each recipient' do
      delivery = double
      expect(delivery).to receive(:deliver_now).exactly(count).times
      allow(ReportMailer).to receive(:daily).and_return(delivery).exactly(count).times

      reporter.report
    end
  end
end
