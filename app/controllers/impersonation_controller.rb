class ImpersonationController < ApplicationController
  before_action :authorize_super_admin
  def impersonate
    account = impersonable_account
    raise 'No account for organization' if account.blank?
    impersonate_account(account)
    redirect_to request.referer
  end

  private

  def impersonable_account
    Account.joins(:user)
           .where(users: {
                    organization_id: params[:organization_id].to_i
                  }).first
  end

  def authorize_super_admin
    authorize(true_account, :super_admin?)
  end
end
