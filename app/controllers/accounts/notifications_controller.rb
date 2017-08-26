class Accounts::NotificationsController < ApplicationController

  def show
    @account = authorize(Account.find(params[:account_id]))
  end

  def update
    @account = authorize Account.find(params[:account_id])

    if @account.update(permitted_attributes(Account))
      redirect_to account_notifications_path(@account), notice: update_notice
    else
      render :show
    end
  end

  private

  def update_notice
    'Notification preferences saved!'
  end

end
