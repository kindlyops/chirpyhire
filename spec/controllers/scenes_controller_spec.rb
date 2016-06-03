require 'rails_helper'

RSpec.describe ScenesController, type: :controller do
  let(:account) { create(:account) }

  before(:each) do
    sign_in(account)
  end

  describe "#show" do
    it "is OK" do
      get :show
      expect(response).to be_ok
    end

    it "is a YAML file" do
      get :show

      expect {
        YAML.parse(response.body)
      }.not_to raise_error
    end
  end
end
