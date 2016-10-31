require 'rails_helper'

RSpec.describe ImpersonationController, type: :controller do
  let(:super_org) { create(:organization, :with_subscription) }
  let(:super_user) { create(:user, organization: super_org) }
  let(:super_account) {
    create(
      :account,
      user: super_user,
      super_admin: true
    )
  }
  let(:normal_org) { create(:organization, :with_subscription, :with_account) }
  let(:normal_account) { normal_org.accounts.first }
  context 'all actions' do
    it 'blocks non super users' do
      sign_in(normal_account)
      ImpersonationController.instance_methods(false).each do |method|
        expect {
          post method.to_sym, params: { organization_id: super_org.id }
        }.not_to change { session['impersonated_account_id'] }
      end
    end
  end
  context '#impersonate' do
    it 'successfully impersonates' do
      @request.env['HTTP_REFERER'] = '/'
      sign_in(super_account)
      expect {
        post :impersonate, params: { organization_id: normal_org.id }
      }.to change {
        session['impersonated_account_id']
      }.from(nil).to(normal_account.id)
    end
    it "doesn't change the true account" do
      @request.env['HTTP_REFERER'] = '/'
      sign_in(super_account)
      expect {
        post :impersonate, params: { organization_id: normal_org.id }
      }.not_to change { subject.true_account }
    end
  end
end
