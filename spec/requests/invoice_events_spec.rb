require 'rails_helper'

RSpec.describe 'Invoice Events' do
  def stub_event(event, body, status = 200)
    stub_request(:get, "https://api.stripe.com/v1/events/#{event}")
      .to_return(status: status, body: body)
  end

  %w[invoice.payment_succeeded].each do |event|
    describe event do
      let(:body) { File.read("spec/support/fixtures/#{event}.json") }
      let(:event_invoice) { JSON.parse(body)['data']['object'] }
      let!(:organization) { create(:organization, stripe_id: event_invoice['customer']) }
      let(:params) do
        {
          id: event
        }
      end

      before do
        prepare_signature StripeEvent.signing_secret, "id=#{event}"
        stub_event event, body
      end

      context 'invoice does not exist' do
        it 'creates an invoice email' do
          expect(InvoiceMailer).to receive_message_chain(:invoice, :deliver_later)
          post '/stripe/events', params: params, env: @env
        end
      end

      context 'invoice already exists' do
        let!(:invoice) { create(:invoice, stripe_id: event, organization: organization) }

        it 'creates an invoice email' do
          expect(InvoiceMailer).to receive_message_chain(:invoice, :deliver_later)
          post '/stripe/events', params: params, env: @env
        end
      end
    end
  end

  %w[invoice.upcoming].each do |event|
    describe event do
      let(:body) { File.read("spec/support/fixtures/#{event}.json") }
      let(:event_invoice) { JSON.parse(body)['data']['object'] }
      let!(:organization) { create(:organization, stripe_id: event_invoice['customer']) }
      let(:params) do
        {
          id: event
        }
      end

      before do
        prepare_signature StripeEvent.signing_secret, "id=#{event}"
        stub_event event, body
      end

      context 'invoice does not exist' do
        it 'creates an invoice' do
          allow(BillingClerkJob).to receive(:perform_later)
          expect {
            post '/stripe/events', params: params, env: @env
          }.to change { Invoice.count }.by(1)
        end

        it 'creates a BillingClerkJob' do
          expect(BillingClerkJob).to receive(:perform_later)
          post '/stripe/events', params: params, env: @env
        end
      end

      context 'invoice already exists' do
        let!(:invoice) { create(:invoice, stripe_id: event, organization: organization) }

        it 'updates the invoice' do
          allow(BillingClerkJob).to receive(:perform_later)
          expect {
            post '/stripe/events', params: params, env: @env
          }.to change { invoice.reload.updated_at }
        end

        it 'creates a BillingClerkJob' do
          expect(BillingClerkJob).to receive(:perform_later)
          post '/stripe/events', params: params, env: @env
        end
      end
    end
  end

  %w[invoice.payment_failed
     invoice.sent
     invoice.updated
     invoice.payment_succeeded
     invoice.created].each do |event|
    describe event do
      let(:body) { File.read("spec/support/fixtures/#{event}.json") }
      let(:event_invoice) { JSON.parse(body)['data']['object'] }
      let!(:organization) { create(:organization, stripe_id: event_invoice['customer']) }
      let(:params) do
        {
          id: event
        }
      end

      before do
        prepare_signature StripeEvent.signing_secret, "id=#{event}"
        stub_event event, body
      end

      context 'invoice does not exist' do
        it 'creates an invoice' do
          expect {
            post '/stripe/events', params: params, env: @env
          }.to change { Invoice.count }.by(1)
        end
      end

      context 'invoice already exists' do
        let!(:invoice) { create(:invoice, stripe_id: event, organization: organization) }

        it 'updates the invoice' do
          expect {
            post '/stripe/events', params: params, env: @env
          }.to change { invoice.reload.updated_at }
        end
      end
    end
  end
end
