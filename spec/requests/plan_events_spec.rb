require 'rails_helper'

RSpec.describe 'Plan Events' do
  def bypass_event_signature(payload)
    event = Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))
    expect(Stripe::Webhook).to receive(:construct_event).and_return(event)
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
        bypass_event_signature body
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
