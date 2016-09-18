require 'rails_helper'

RSpec.describe Payment::Job::ProcessSubscription do
  let(:subscription) { create(:subscription) }
  let(:email) { Faker::Internet.email }

  describe '#perform' do
    it 'calls Process Service' do
      expect(Payment::Subscriptions::Process).to receive(:call).with(subscription, email)
      described_class.perform_now(subscription, email)
    end

    it 'calls the SurveyAdvancer service' do
      allow(Payment::Subscriptions::Process).to receive(:call).with(subscription, email)
      expect(SurveyAdvancer).to receive(:call).with(subscription.organization)
      described_class.perform_now(subscription, email)
    end
  end
end
