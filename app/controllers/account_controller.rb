class AccountController < ApplicationController
  def show
    @account = authorize current_account
  end

  def update
    @account = authorize current_account

    if @account.update(permitted_attributes(Account))
      redirect_to account_path, notice: update_notice
    else
      render :show
    end
  end

  private

  def update_notice
    "#{@account.name} updated!"
  end
end
