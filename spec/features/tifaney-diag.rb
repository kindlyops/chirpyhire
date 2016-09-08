require 'rails_helper'
require 'automaton'
RSpec.describe Sms::SubscriptionsController, type: :controller do
  Rails.application.config.active_job.queue_adapter = :inline

  let(:account) { create(:account) }
  let!(:plan) { create(:plan) }
  let(:registrar) { Registrar.new(account) }
  let(:organization) { account.organization }
  let(:survey) { organization.survey }
  let(:erica) { create(:candidate, organization: organization) }
  describe "erica" do
    include ActiveJob::TestHelper
    let(:params) do
      {
        "To" => organization.phone_number,
        "From" => erica.phone_number,
        "Body" => "START",
        "MessageSid" => "1"
      }
    end

    it "starts the subscription" do
      perform_enqueued_jobs do
        registrar.register
        post :create, params: params
        binding.pry
        expect(organization.messages.by_recency.last.inquiry.type).to eq("AddressQuestion")
        expect(erica.subscribed?).to be true
      end
    end 
  end
end