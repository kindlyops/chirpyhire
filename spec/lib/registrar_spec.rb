require 'rails_helper'

RSpec.describe Registrar do
  let(:registrar) { Registrar.new(account) }

  let(:organization) { account.organization }
  let!(:location) { create(:location, organization: organization) }
  let!(:plan) { create(:plan) }

  describe "#register" do
    context "when the organization is persisted" do
      let(:account) { create(:account) }

      it "creates three rules for the organization" do
        expect {
          registrar.register
        }.to change{organization.rules.count}.by(3)
      end

      it "creates two actionables" do
        expect {
          registrar.register
        }.to change{Actionable.count}.by(2)
      end

      it "creates a survey" do
        expect {
          registrar.register
        }.to change{organization.survey.present?}.from(false).to(true)
      end

      it "enqueues a TwilioProvisioner job" do
        expect {
          registrar.register
        }.to have_enqueued_job(TwilioProvisionerJob)
      end

      it "creates three questions" do
        expect {
          registrar.register
        }.to change{Question.count}.by(3)
      end

      it "creates a dummy candidate with candidate features" do
        expect {
          registrar.register
        }.to change{organization.candidates.count}.by(1)
        candidate = organization.candidates.first

        expect(candidate.address_feature.present?).to eq(true)
        expect(candidate.choice_features.first.present?).to eq(true)
        expect(candidate.yes_no_features.first.present?).to eq(true)
      end

      it "creates a trial subscription" do
        expect {
          registrar.register
        }.to change{organization.reload.subscription.present?}.from(false).to(true)

        expect(organization.subscription.trialing?).to eq(true)
        expect(organization.subscription.plan).to eq(plan)
        expect(organization.subscription.trial_message_limit).to eq(100)
      end

      it "creates a welcome, bad fit, thank you template for the survey" do
        expect {
          registrar.register
        }.to change{Template.count}.by(3)
      end
    end

    context "when the organization is not persisted" do
      let(:organization) { build(:organization) }
      let(:user) { build(:user, organization: organization) }
      let(:account) { build(:account, user: user) }
      let!(:location) { build(:location, organization: organization) }

      it "does not create a survey" do
        expect {
          registrar.register
        }.not_to change{organization.survey.present?}
      end

      it "does not create a welcome, bad fit, thank you template for the survey" do
        expect {
          registrar.register
        }.not_to change{Template.count}
      end
    end
  end
end
