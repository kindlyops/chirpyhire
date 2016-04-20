require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  context "not logged in" do
    it "302s" do
      post :create
      expect(response.status).to eq(302)
    end
  end

  context "logged in" do
    let(:account) { create(:account, :with_organization, :with_user) }
    let(:organization) { account.organization }

    before(:each) do
      sign_in(account)
    end

    context "without any leads" do
      it "does not create a search" do
      end

      it "sets a flash error saying there are no leads" do
      end
    end

    context "with valid search params" do
      let!(:questions) { create_list(:question, 3, organization: organization) }
      let!(:leads) { create_list(:lead, 2, organization: organization) }

      let(:params) do
        { search: {
          question_ids: [questions.first.id, questions.last.id]
          }
        }
      end

      it "is OK" do
        post :create, params
        expect(response).to be_ok
      end

      it "creates a search" do
        expect {
          post :create, params
        }.to change{organization.searches.count}.by(1)
      end

      it "creates search questions" do
        expect {
          post :create, params
        }.to change{SearchQuestion.count}.by(params[:search][:question_ids].length)
      end

      it "creates search leads" do
        expect {
          post :create, params
        }.to change{SearchLead.count}.by(organization.leads.count)
      end

      it "creates an InquisitorJob for each lead in the organization" do
        expect {
          post :create, params
        }.to change(InquisitorJob.queue_adapter.enqueued_jobs, :size).by(organization.leads.count)
      end
    end
  end
end
