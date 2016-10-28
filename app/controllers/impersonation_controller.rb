class ImpersonationController < ApplicationController
  before_action :authorize_super_admin
  def impersonate
    account = Account.joins(:user)
                     .where(users: {
                              organization_id: params[:organization_id].to_i
                            }).first
    raise 'No account for org' if account.blank?
    impersonate_account(account)
    redirect_to request.referrer
  end

  private

  def authorize_super_admin
    authorize(true_account, :super_admin?)
  end
end
