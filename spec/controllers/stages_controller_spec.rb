require 'rails_helper'

RSpec.describe StagesController, type: :controller do
  let(:organization) { create(:organization, :with_subscription, :with_account) }
  let(:account) { organization.accounts.first }
  let(:user) { account.user }

  before(:each) do
    sign_in(account)
  end

  describe "#index" do
    it "is OK" do
      get :index
      expect(response).to be_ok
    end
  end

  describe '#modify' do
    let!(:delete_me_stage) { create(:stage, organization: organization, name: "delete_me", order: 5)}

    it "can create a stage" do
      get :create, params: { new_stage: "Test stage" }
      expect(organization.stages.count).to eq(6)
      expect(organization.stages.last.name).to eq("Test stage")
    end

    it "can not create a stage with the same name" do
      get :create, params: { new_stage: "Potential" }
      expect(organization.stages.count).to eq(5)
      expect(response.request.env["rack.session"]["flash"]["flashes"]["alert"]).to have_text("Oops")
    end

    it "can delete stage" do
      expect(organization.stages.count).to eq(5)
      get :destroy, params: {id: delete_me_stage.id}
      expect(organization.stages.count).to eq(4)
    end
  end
end
