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
end
