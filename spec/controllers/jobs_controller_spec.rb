require 'rails_helper'

RSpec.describe JobsController, type: :controller do
  context "not logged in" do
    describe "#new" do
      it "302s" do
        get :new
        expect(response.status).to eq(302)
      end
    end

    describe "#index" do
      it "302s" do
        get :index
        expect(response.status).to eq(302)
      end
    end

    describe "#create" do
      it "302s" do
        post :create
        expect(response.status).to eq(302)
      end
    end
  end

  context "logged in" do
    let(:account) { create(:account, :with_organization) }
    let(:organization) { account.organization }

    before(:each) do
      sign_in(account)
    end

    describe "#new" do
      it "assigns a new job search as @job" do
        get :new
        expect(assigns(:job)).to be_a(JobPresenter)
        expect(assigns(:job).job).to be_a_new(Job)
        expect(assigns(:job).account).to eq(account)
      end
    end

    describe "#index" do
      it "is OK" do
        get :index
        expect(response).to be_ok
      end

      context "with jobs" do
        let!(:jobs) { create_list(:job, 3, account: account) }

        it "returns the organization's jobs" do
          get :index
          expect(assigns(:jobs)).to eq(jobs)
        end

        context "with other organizations" do
          let!(:other_jobs) { create_list(:job, 2) }
          it "does not return the other organization's jobs" do
            get :index
            expect(assigns(:jobs)).not_to include(other_jobs)
          end
        end
      end
    end

    describe "#create" do
      context "with valid question ids" do
        let!(:questions) do
          questions = create_list(:question, 3)
          organization.questions << questions
          questions
        end

        let(:params) do
          { job: {
            question_ids: [questions.first.id, questions.last.id]
            }
          }
        end

        context "with candidates" do
          let!(:candidates) { create_list(:candidate, 2, :with_subscription, organization: organization) }

          it "creates a job" do
            expect {
              post :create, params
            }.to change{organization.jobs.count}.by(1)
          end

          it "creates job questions" do
            expect {
              post :create, params
            }.to change{JobQuestion.count}.by(params[:job][:question_ids].length)
          end

          it "creates job candidates" do
            expect {
              post :create, params
            }.to change{JobCandidate.count}.by(organization.candidates.count)
          end

          it "creates an InquisitorJob for each candidate in the organization" do
            expect {
              post :create, params
            }.to change(InquisitorJob.queue_adapter.enqueued_jobs, :size).by(organization.candidates.count)
          end

          it "redirects to the search" do
            post :create, params
            expect(response).to redirect_to(organization.jobs.last)
          end

          context "with invalid job search params" do
            before(:each) do
              request.env["HTTP_REFERER"] = "origin"
            end

            let(:invalid_params) do
              { job: {} }
            end

            it "redirects back" do
              post :create, invalid_params
              expect(response).to redirect_to("origin")
            end

            it "does not create a job" do
              expect {
                post :create, invalid_params
              }.not_to change{organization.jobs.count}
            end

            it "sets a flash error notifying that no questions were selected" do
              post :create, invalid_params
              expect(flash[:alert]).to include("No questions selected!")
            end
          end
        end

        context "without any subscribed candidates" do
          let!(:candidates) { create_list(:candidate, 2, organization: organization) }

          before(:each) do
            request.env["HTTP_REFERER"] = "origin"
          end

          it "redirects back" do
            post :create, params
            expect(response).to redirect_to("origin")
          end

          it "does not create a job" do
            expect {
              post :create, params
            }.not_to change{organization.jobs.count}
          end

          it "sets a flash alert saying there are no subscribed candidates" do
            post :create, params
            expect(flash[:alert]).to include("There are no subscribed candidates!")
          end
        end
      end
    end
  end
end
