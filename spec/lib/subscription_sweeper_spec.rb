require 'rails_helper'

RSpec.describe SubscriptionSweeper do
  subject { SubscriptionSweeper.new }

  describe 'call' do
    context 'with trial subscription' do
      let!(:subscription) { create(:subscription) }
      context 'and the trial has ended' do
        before do
          subscription.update(trial_ends_at: 100.days.ago)
        end

        it 'cancels the subscription' do
          expect {
            subject.call
          }.to change { subscription.reload.internal_status }.from('trialing').to('canceled')
        end
      end
    end
  end
end
