require 'rails_helper'

RSpec.describe Payment::Subscriptions::Create do
  let(:organization) { create(:organization) }
  let(:subscription) { create(:subscription, organization: organization) }
  let(:stripe_token) { "token" }

  subject { Payment::Subscriptions::Create.new(subscription, stripe_token) }

  describe "#call" do
    it "sets the stripe token on the organization" do
      expect {
        subject.call
      }.to change{organization.stripe_token}.from(nil).to(stripe_token)
    end

    it "returns the subscription" do
      expect(subject.call).to be_a(Subscription)
    end

    context "with a valid subscription" do
      it "kicks off a job to process the subscription" do
        expect{
          subject.call
        }.to have_enqueued_job(Payment::ProcessSubscriptionJob).with(subscription)
      end
    end
  end
end
