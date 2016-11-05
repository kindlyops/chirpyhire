require 'rails_helper'

RSpec.describe Maps::CandidatesController, type: :controller do
  let(:organization) { create(:organization, :with_subscription, :with_account) }
  let(:account) { organization.accounts.first }
  before(:each) do
    sign_in(account)
  end

  describe '#show' do
    let(:candidate) { create(:candidate, organization: organization) }
    let(:params) do
      {
        id: candidate.id
      }
    end

    it 'is ok' do
      get :show, params: params
      expect(response).to be_ok
    end
  end

  describe '#index' do
    it 'is ok' do
      get :index
      expect(response).to be_ok
    end
  end
end
