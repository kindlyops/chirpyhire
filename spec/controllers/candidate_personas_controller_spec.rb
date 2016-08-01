require 'rails_helper'

RSpec.describe CandidatePersonasController, type: :controller do
  let(:user) { create(:user, :with_account) }
  let(:account) { user.account }
  let(:organization) { user.organization }

  before(:each) do
    sign_in(account)
  end

  describe "#show" do
    it "is ok" do
      get :show
      expect(response).to be_ok
    end
  end
end
