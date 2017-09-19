require 'rails_helper'

RSpec.describe 'Plan Events' do
  def stub_event(event, body, status = 200)
    stub_request(:get, "https://api.stripe.com/v1/events/#{event}")
      .to_return(status: status, body: body)
  end

  %w[plan.created
     plan.deleted
     plan.updated].each do |event|
    describe event do
      let(:body) { File.read("spec/support/fixtures/#{event}.json") }
      let(:event_plan) { JSON.parse(body)['data']['object'] }
      let(:params) do
        {
          id: event
        }
      end

      before do
        prepare_signature StripeEvent.signing_secret, "id=#{event}"
        stub_event event, body
      end

      context 'plan does not exist' do
        it 'creates an plan' do
          expect {
            post '/stripe/events', params: params, env: @env
          }.to change { Plan.count }.by(1)
        end
      end

      context 'plan already exists' do
        let!(:plan) { create(:plan, stripe_id: event) }

        it 'updates the plan' do
          expect {
            post '/stripe/events', params: params, env: @env
          }.to change { plan.reload.updated_at }
        end
      end
    end
  end
end
