require 'rails_helper'

RSpec.describe "Stripe Events" do
  def stub_event(fixture_id, status = 200)
    stub_request(:get, "https://api.stripe.com/v1/events/#{fixture_id}").
      to_return(status: status, body: File.read("spec/support/fixtures/#{fixture_id}.json"))
  end

  before(:each) do |example|
    stub_event(example.description)
    http_login("stripe", StripeEvent.authentication_secret)
  end

  describe "enqueuing jobs" do
    it "customer.subscription.created" do |example|
      expect {
        post "/stripe/events", params: { id: example.description }, env: @env
      }.to have_enqueued_job(Payment::Job::RefreshSubscription)
    end

    it "customer.subscription.deleted" do |example|
      expect {
        post "/stripe/events", params: { id: example.description }, env: @env
      }.to have_enqueued_job(Payment::Job::RefreshSubscription)
    end

    it "customer.subscription.trial_will_end" do |example|
      expect {
        post "/stripe/events", params: { id: example.description }, env: @env
      }.to have_enqueued_job(Payment::Job::RefreshSubscription)
    end

    it "customer.subscription.updated" do |example|
      expect {
        post "/stripe/events", params: { id: example.description }, env: @env
      }.to have_enqueued_job(Payment::Job::RefreshSubscription)
    end

    it "charge.failed" do |example|
      expect {
        post "/stripe/events", params: { id: example.description }, env: @env
      }.to have_enqueued_job(ActionMailer::DeliveryJob)
    end

    it "charge.succeeded" do |example|
      expect {
        post "/stripe/events", params: { id: example.description }, env: @env
      }.to have_enqueued_job(ActionMailer::DeliveryJob)
    end
  end

  describe "successful events" do
    it "customer.subscription.created" do |example|
      post "/stripe/events", params: { id: example.description }, env: @env
      expect(response).to be_ok
    end

    it "customer.subscription.deleted" do |example|
      post "/stripe/events", params: { id: example.description }, env: @env
      expect(response).to be_ok
    end

    it "customer.subscription.trial_will_end" do |example|
      post "/stripe/events", params: { id: example.description }, env: @env
      expect(response).to be_ok
    end

    it "customer.subscription.updated" do |example|
      post "/stripe/events", params: { id: example.description }, env: @env
      expect(response).to be_ok
    end

    it "charge.failed" do |example|
      post "/stripe/events", params: { id: example.description }, env: @env
      expect(response).to be_ok
    end

    it "charge.succeeded" do |example|
      post "/stripe/events", params: { id: example.description }, env: @env
      expect(response).to be_ok
    end
  end
end
