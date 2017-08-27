class Internal::Logger::SetContactStage
  def self.call(account, stage, timestamp)
    new(account, stage, timestamp).call
  end

  def initialize(account, stage, timestamp)
    @account = account
    @stage = stage
    @timestamp = timestamp
  end

  attr_reader :account, :stage, :timestamp
  delegate :organization, to: :account

  def call
    setup_user_properties
    track
  end

  def track
    Heap.track(
      'Set Candidate Stage',
      account.id.to_s,
      { name: stage.name, id: stage.id },
      timestamp
    )
  end

  def setup_user_properties
    Heap.add_user_properties account.id.to_s, user_properties
  end

  def user_properties
    { name: account.name,
      email: account.email,
      organization_id: organization.id,
      organization_name: organization.name,
      subscription_status: organization.subscription_status }
  end
end
