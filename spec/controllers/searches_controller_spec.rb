require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  context "not logged in" do
    it "302s" do
      post :create
      expect(response.status).to eq(302)
    end
  end

  context "logged in" do
    let(:account) { create(:account, :with_organization) }
    let(:organization) { account.organization }

    before(:each) do
      sign_in(account)
    end

    describe "#new" do
      it "assigns a new search as @search" do
        get :new
        expect(assigns(:search)).to be_a_new(Search)
        expect(assigns(:search).account).to eq(account)
      end
    end

    describe "#create" do
      context "with valid question ids" do
        let!(:questions) { create_list(:question, 3, organization: organization) }

        let(:params) do
          { search: {
            question_ids: [questions.first.id, questions.last.id]
            }
          }
        end

        context "with leads" do
          let!(:leads) { create_list(:lead, 2, organization: organization) }

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

          context "with invalid search params" do
            before(:each) do
              request.env["HTTP_REFERER"] = "origin"
            end

            let(:invalid_params) do
              { search: {} }
            end

            it "redirects back" do
              post :create, invalid_params
              expect(response).to redirect_to("origin")
            end

            it "does not create a search" do
              expect {
                post :create, invalid_params
              }.not_to change{organization.searches.count}
            end

            it "sets a flash error notifying that no questions were selected" do
              post :create, invalid_params
              expect(flash[:alert]).to include("No questions selected!")
            end
          end
        end

        context "without any leads" do
          before(:each) do
            request.env["HTTP_REFERER"] = "origin"
          end

          it "redirects back" do
            post :create, params
            expect(response).to redirect_to("origin")
          end

          it "does not create a search" do
            expect {
              post :create, params
            }.not_to change{organization.searches.count}
          end

          it "sets a flash alert saying there are no leads" do
            post :create, params
            expect(flash[:alert]).to include("There are no leads!")
          end
        end
      end
    end
  end
end
