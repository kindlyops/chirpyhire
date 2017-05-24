require 'rails_helper'

RSpec.describe NewTeamNotification do
  let(:team) { create(:team, :owner) }
  let(:account) { team.accounts.first }
  let!(:owners) { create_list(:account, 3, :owner, organization: team.organization) }

  subject { NewTeamNotification.new(team) }

  describe '#call' do
    context 'with owners' do
      it 'creates a mailing for every owner but the one passed in' do
        expect {
          subject.call
        }.to have_enqueued_job(ActionMailer::DeliveryJob)
          .with { |mailer, mailer_method, *_args|
               expect(mailer).to eq('NotificationMailer')
               expect(mailer_method).to eq('team_created')
             }.exactly(owners.count + 1).times
      end
    end
  end
end
