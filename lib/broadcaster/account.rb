class Broadcaster::Account
  def self.broadcast(account)
    new(account).broadcast
  end

  def initialize(account)
    @account = account
  end

  def broadcast
    AccountsChannel.broadcast_to(account, account_hash)
  end

  private

  attr_reader :account

  def account_hash
    JSON.parse(account_string)
  end

  def account_string
    AccountsController.render partial: 'accounts/account',
                              locals: { account: account.decorate }
  end
end
