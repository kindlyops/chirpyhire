class RailsAdmin::ParentController < ActionController::Base
  def impersonate_account(impersonatee)
    real_account = warden.user(:account)
    not_impersonating = session[:impersonated_account_id].blank?
    session[:real_account_id] = real_account.id if not_impersonating
    warden.logout(:account)
    session[:impersonated_account_id] = impersonatee.id
    warden.set_user(impersonatee, scope: :account)
  end
end
