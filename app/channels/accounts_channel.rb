class AccountsChannel < ApplicationCable::Channel
  def subscribed
    reject if account.blank?
    stream_for account
  end

  private

  def account
    @account ||= authorize(Account.find(params[:id]), :show?)
  end
end
