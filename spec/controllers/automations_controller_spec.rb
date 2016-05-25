require 'rails_helper'

RSpec.describe AutomationsController, type: :controller do
  let(:user) { create(:user, :with_account) }

  before(:each) do
    sign_in(user.account)
  end

  describe "#show" do
    let(:automation) { create(:automation, organization: user.organization) }

    it "is OK" do
      get :show, id: automation.id
      expect(response).to be_ok
    end
  end
end
