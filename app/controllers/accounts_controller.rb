class AccountsController < ApplicationController
  before_action :require_super_admin!, only: :stop_impersonating
  skip_after_action :verify_authorized, only: :stop_impersonating
  decorates_assigned :account

  def stop_impersonating
    stop_impersonating_account
    restore_real_account
    redirect_to rails_admin.index_path('account')
  end

  def show
    @account = authorize Account.find(params[:id])

    respond_to do |format|
      format.json
      format.html
    end
  end

  def update
    @account = authorize Account.find(params[:id])

    if @account.update(permitted_attributes(Account))
      redirect_to account_path(@account), notice: update_notice
    else
      render :show
    end
  end

  private

  def stop_impersonating_account
    session.delete(:impersonated_account_id)
    warden.logout(:account)
  end

  def restore_real_account
    real_account_id = session.delete(:real_account_id)
    return if real_account_id.blank?
    real_account = Account.find(real_account_id)
    warden.set_user(real_account, scope: :account)
    @current_account = nil
  end

  def update_notice
    'Profile updated!'
  end

  def require_super_admin!
    redirect_to root_path unless impersonating? && true_account.super_admin?
  end
end
