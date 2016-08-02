require 'rails_helper'

RSpec.describe Registrar do
  let(:registrar) { Registrar.new(account) }
  let(:organization) { account.organization }

  describe "#register" do
    context "when the organization is persisted" do
      let(:account) { create(:account) }

      it "creates a survey" do
        expect {
          registrar.register
        }.to change{organization.survey.present?}.from(false).to(true)
      end

      it "creates a template for the candidate persona" do
        expect {
          registrar.register
        }.to change{organization.templates.count}.by(1)
        expect(organization.survey.template.id).to eq(organization.templates.first.id)
      end
    end

    context "when the organization is not persisted" do
      let(:organization) { build(:organization) }
      let(:user) { build(:user, organization: organization) }
      let(:account) { build(:account, user: user) }

      it "does not create a survey" do
        expect {
          registrar.register
        }.not_to change{organization.survey.present?}
      end

      it "does not create a template for the candidate persona" do
        expect {
          registrar.register
        }.not_to change{organization.templates.count}
      end
    end
  end
end
