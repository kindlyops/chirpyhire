require 'rails_helper'

RSpec.describe Maps::CandidatesController, type: :controller do
  let(:account) { create(:account) }
  before(:each) do
    sign_in(account)
  end

  describe "#show" do
    let(:params) do
      {
        id: 1
      }
    end

    it "is ok" do
      get :show, params: params
      expect(response).to be_ok
    end
  end

  describe "#index" do
    it "is ok" do
      get :index
      expect(response).to be_ok
    end
  end
end
