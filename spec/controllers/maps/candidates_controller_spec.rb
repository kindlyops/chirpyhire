# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Maps::CandidatesController, type: :controller do
  let(:account) { create(:account, :with_subscription) }
  before do
    sign_in(account)
  end

  describe '#show' do
    let(:params) do
      {
        id: 1
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
