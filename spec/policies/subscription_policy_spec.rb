require 'rails_helper'

RSpec.describe SubscriptionPolicy do
  subject { described_class.new(organization, subscription) }

  let(:subscription) { create(:subscription) }
  let(:organization) { subscription.organization }

  let(:resolved_scope) { SubscriptionPolicy::Scope.new(organization, Subscription.all).resolve }

  it { should permit_new_and_create_actions }
  it 'includes subscription in resolved scope' do
    expect(resolved_scope).to include(subscription)
  end

  it { should permit_mass_assignment_of(:plan_id) }
  it { should permit_mass_assignment_of(:quantity) }

  it { should permit_edit_and_update_actions }
  it { should permit_action(:destroy) }
  it { should permit_action(:show) }

  context 'subscription does not belong to the organization' do
    let(:organization) { create(:organization) }

    it 'excludes subscription in resolved scope' do
      expect(resolved_scope).not_to include(subscription)
    end

    it { should forbid_edit_and_update_actions }
    it { should forbid_action(:destroy) }
    it { should forbid_action(:show) }
  end
end
