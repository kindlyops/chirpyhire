require 'rails_helper'

RSpec.describe TemplatesController, type: :controller do
  let(:user) { create(:user, :with_account) }
  let(:account) { user.account }
  let(:organization) { user.organization }

  before(:each) do
    sign_in(account)
  end

  describe "#preview" do
    render_views

    let(:template) { create(:template, organization: organization, body: "Hello this is {{organization.name}}. We're so glad you are interested in learning about opportunities here. We have a few questions to ask you via text message.")}
    let(:rendered_template) { "Hello this is #{organization.name}. We're so glad you are interested in learning about opportunities here. We have a few questions to ask you via text message." }

    it "is a rendered template" do
      get :preview, xhr: true, params: { template_id: template.id, user_id: user.id }
      expect(response.body).to eq(rendered_template)
    end
  end

  describe "#index" do
    it "is OK" do
      get :index
      expect(response).to be_ok
    end

    context "with templates" do
      let!(:templates) { create_list(:template, 3, organization: organization) }

      it "returns the organization's templates" do
        get :index
        expect(assigns(:templates)).to eq(templates)
      end

      context "with other organizations" do
        let!(:other_templates) { create_list(:template, 2) }
        it "does not return the other organization's templates" do
          get :index
          expect(assigns(:templates)).not_to include(other_templates)
        end
      end
    end
  end
end
