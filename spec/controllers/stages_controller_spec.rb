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

  describe '#create' do
    it "can create a stage" do
      expect {
        get :create, params: { new_stage: "Test stage" }
      }.to change{organization.stages.count}.from(4).to(5)
      expect(organization.stages.last.name).to eq("Test stage")
    end

    it "can not create a stage with the same name" do
      expect {
        get :create, params: { new_stage: "Potential" }
      }.not_to change{organization.stages.count}
    end
  end

  describe '#destroy' do
    let!(:delete_me_stage) { create(:stage, organization: organization, name: "delete_me", order: 5)}
    it "can delete stage" do
      expect {
        get :destroy, params: {id: delete_me_stage.id}
      }.to change{organization.stages.count}.by(-1)
    end
  end
end
