require 'rails_helper'

RSpec.describe ImpersonationController, type: :controller do
  let(:organization1) { create(:organization, :with_subscription) }
  let(:user1) { create(:user, organization: organization1) }
  let(:super_account) {
    create(
      :account,
      user: user1,
      super_admin: true,
      )
    }
  let(:organization2) { create(:organization, :with_subscription, :with_account) }
  let(:normal_account) { organization2.accounts.first }
  let(:user2) { normal_account.user }
  context 'all actions' do
    it 'blocks non super users' do
      sign_in(normal_account)
      ImpersonationController.instance_methods(false).each do |method|
        expect {
          post :impersonate, params: { organization_id: organization1.id }
        }.to change { flash[:error] }.to('You cannot perform this action.')
      end
    end
  end
  context '#impersonate' do
    it 'successfully impersonates' do
      @request.env['HTTP_REFERER'] = '/'
      sign_in(super_account)
      expect {
        post :impersonate, params: { organization_id: organization2.id }
      }.to change(
        { subject.current_account }.from(super_account).to(normal_account)
      )
    end
    it "doesn't change the true account" do
      @request.env['HTTP_REFERER'] = '/'
      sign_in(super_account)
      expect {
        post :impersonate, params: { organization_id: organization2.id }
      }.not_to change{ subject.true_account }
    end
  end
end
