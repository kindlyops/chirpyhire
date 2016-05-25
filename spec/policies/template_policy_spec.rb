require 'rails_helper'

RSpec.describe TemplatePolicy do
  subject { TemplatePolicy.new(account, template) }

  let(:template) { create(:template) }

  let(:resolved_scope) { TemplatePolicy::Scope.new(account, Template.all).resolve }

  context "being a visitor" do
    let(:account) { nil }

    it "raises a NotAuthorizedError" do
      expect {
        subject
      }.to raise_error(Pundit::NotAuthorizedError)
    end
  end

  context "having an account" do
    context "account is on a different organization" do
      let(:account) { create(:account) }

      it 'excludes template in resolved scope' do
        expect(resolved_scope).not_to include(template)
      end
      it { should forbid_new_and_create_actions }
      it { should forbid_edit_and_update_actions }
      it { should forbid_action(:destroy) }
      it { should forbid_action(:show) }
      it { should forbid_action(:preview) }
    end

    context "account is on the same organization as the template" do
      let(:user) { create(:user, organization: template.organization) }
      let(:account) { create(:account, user: user) }

      it 'includes template in resolved scope' do
        expect(resolved_scope).to include(template)
      end

      it { should forbid_new_and_create_actions }
      it { should forbid_edit_and_update_actions }
      it { should forbid_action(:destroy) }
      it { should forbid_action(:show) }
      it { should permit_action(:preview) }
    end
  end
end
