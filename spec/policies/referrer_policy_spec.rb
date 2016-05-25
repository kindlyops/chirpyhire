require 'rails_helper'

RSpec.describe ReferrerPolicy do
  let(:account) { create(:account) }
  subject { ReferrerPolicy.new(account, referrer) }

  let(:referrer) { create(:referrer) }

  let(:resolved_scope) { ReferrerPolicy::Scope.new(account, Referrer.all).resolve }

  it { should forbid_new_and_create_actions }
  it { should forbid_edit_and_update_actions }
  it { should forbid_action(:destroy) }

  context "having an account" do
    context "account is on a different organization" do
      it 'excludes referrer in resolved scope' do
        expect(resolved_scope).not_to include(referrer)
      end
    end

    context "account is on the same organization as the referrer" do
      let(:user) { create(:user, organization: referrer.organization) }
      let(:account) { create(:account, user: user) }

      it 'includes referrer in resolved scope' do
        expect(resolved_scope).to include(referrer)
      end
    end
  end
end
