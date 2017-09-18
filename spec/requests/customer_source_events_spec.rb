require 'rails_helper'

RSpec.describe 'Customer Source Events' do
  def stub_event(event, body, status = 200)
    stub_request(:get, "https://api.stripe.com/v1/events/#{event}")
      .to_return(status: status, body: body)
  end

  %w[customer.source.created
     customer.source.updated
     customer.source.deleted].each do |event|
    describe event do
      let(:body) { File.read("spec/support/fixtures/#{event}.json") }
      let(:event_source) { JSON.parse(body)['data']['object'] }
      let!(:organization) { create(:organization, stripe_id: event_source['customer']) }
      let(:params) do
        {
          id: event
        }
      end

      before do
        prepare_signature StripeEvent.signing_secret, "id=#{event}"
        stub_event event, body
      end

      context 'payment card does not exist' do
        it 'creates an payment card' do
          expect {
            post '/stripe/events', params: params, env: @env
          }.to change { PaymentCard.count }.by(1)
        end
      end

      context 'payment card already exists' do
        let!(:payment_card) { create(:payment_card, stripe_id: event, organization: organization) }

        it 'updates the payment_card' do
          expect {
            post '/stripe/events', params: params, env: @env
          }.to change { payment_card.reload.updated_at }
        end
      end
    end
  end
end
