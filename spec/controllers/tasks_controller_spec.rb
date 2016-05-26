require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:user) { create(:user, :with_account) }
  let(:account) { user.account }
  let(:organization) { user.organization }

  before(:each) do
    sign_in(account)
  end

  describe "#update" do
    let!(:task) { create(:task, organization: organization) }

    context "with valid rule params" do
      let(:task_params) do
        { id: task.id,
          task: {
          done: true
        } }
      end

      it "updates the task" do
        expect {
          xhr :put, :update, task_params
        }.to change{task.reload.done?}.from(false).to(true)
      end
    end

    context "with invalid params" do
      let(:invalid_params) do
        { id: task.id,
          task: {
            message_id: 1
          }
        }
      end

      it "does not create a task" do
        expect {
          xhr :put, :update, invalid_params
        }.not_to change{Task.count}
      end
    end
  end

  describe "#index" do
    it "is OK" do
      get :index
      expect(response).to be_ok
    end

    context "with tasks" do
      let!(:tasks) { create_list(:task, 3, organization: organization) }

      it "returns the organization's tasks" do
        get :index
        expect(assigns(:tasks)).to eq(tasks)
      end

      context "with done tasks" do
        let!(:task) { create(:task, done: true, organization: organization) }

        it "does not include done tasks" do
          get :index
          expect(assigns(:tasks)).not_to include(task)
        end
      end

      context "with other organizations" do
        let!(:other_tasks) { create_list(:task, 2) }
        it "does not return the other organization's tasks" do
          get :index
          expect(assigns(:tasks)).not_to include(other_tasks)
        end
      end
    end
  end
end
