class GlacierBreaker
  def self.call(account)
    new(account).call
  end

  def initialize(account)
    @account = account
  end

  attr_reader :account

  def call
    account.teams.find_each do |team|
      team.contacts.find_each do |contact|
        account.conversations.find_or_create_by!(contact: contact)
      end
    end
  end
end
