class AccountsController < ApplicationController
  before_action :require_super_admin!
  skip_after_action :verify_authorized

  def stop_impersonating
    stop_impersonating_account
    redirect_to rails_admin.index_path('account')
  end

  private

  def require_super_admin!
    redirect_to root_path unless impersonating? && true_account.super_admin?
  end
end
