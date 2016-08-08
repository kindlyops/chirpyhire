require 'rails_helper'

RSpec.describe SurveysController, type: :controller do
  let(:user) { create(:user, :with_account) }
  let(:account) { user.account }
  let(:organization) { user.organization }
  let!(:survey) { organization.create_survey }

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
