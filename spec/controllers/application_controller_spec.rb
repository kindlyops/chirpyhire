require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      head :ok
    end
  end

  context 'not logged in' do
    describe '#index' do
      it '302s' do
        get :index
        expect(response.status).to eq(302)
      end
    end
  end

  context 'logged in' do
    let(:account) { create(:account) }

    before do
      sign_in(account)
    end

    context 'subscription gates' do
      controller do
        skip_after_action :verify_policy_scoped

        def index
          head :ok
        end
      end

      context 'active subscription' do
        let!(:subscription) { create(:subscription, organization: account.organization, state: 'active', quantity: 1) }

        context 'under the monthly message limit' do
          it 'is ok' do
            get :index
            expect(response).to be_ok
          end
        end

        context 'at the monthly message limit' do
          before do
            Plan.messages_per_quantity = 1
            create(:message, user: account.user)
          end

          it 'is ok' do
            get :index
            expect(response).to be_ok
          end
        end

        context 'above the monthly message limit' do
          before do
            Plan.messages_per_quantity = 1
            create_list(:message, 2, user: account.user)
          end

          it 'is ok' do
            get :index
            expect(response).to be_ok
          end
        end
      end

      context 'trialing subscription' do
        let!(:subscription) { create(:subscription, organization: account.organization, state: 'trialing', trial_message_limit: 1) }

        context 'under the trial message limit' do
          it 'is ok' do
            get :index
            expect(response).to be_ok
          end
        end

        context 'at the trial message limit' do
          before do
            create(:message, user: account.user)
          end

          it 'is ok' do
            get :index
            expect(response).to be_ok
          end
        end

        context 'above the trial message limit' do
          before do
            create_list(:message, 2, user: account.user)
          end

          it 'is ok' do
            get :index
            expect(response).to be_ok
          end
        end
      end

      context 'canceled subscription' do
        let!(:subscription) { create(:subscription, organization: account.organization, state: 'canceled') }

        it 'redirects to show_subscription page' do
          get :index
          expect(response).to redirect_to(subscription)
        end
      end
    end
  end
end
