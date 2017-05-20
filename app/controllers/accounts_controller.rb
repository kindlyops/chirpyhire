class AccountsController < ApplicationController
  before_action :require_super_admin!, only: :stop_impersonating
  skip_after_action :verify_authorized, only: :stop_impersonating

  def stop_impersonating
    stop_impersonating_account
    redirect_to rails_admin.index_path('account')
  end

  def show
    @account = authorize Account.find(params[:id])
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

  def update_notice
    "#{@account.name} updated!"
  end

  def require_super_admin!
    redirect_to root_path unless impersonating? && true_account.super_admin?
  end
end
