require 'rails_helper'

RSpec.describe InboxPolicy do
  let(:account) { create(:account) }
  let(:organization) { account.organization }
  let(:inbox) { Inbox.new(organization: organization) }
  subject { InboxPolicy.new(account, inbox) }

  it { should permit_action(:show) }
  it { should forbid_new_and_create_actions }
  it { should forbid_edit_and_update_actions }
  it { should forbid_action(:destroy) }
end
