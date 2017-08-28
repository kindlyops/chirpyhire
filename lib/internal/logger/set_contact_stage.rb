class Internal::Logger::SetContactStage
  def self.call(account, stage, contact, timestamp)
    new(account, stage, contact, timestamp).call
  end

  def initialize(account, stage, contact, timestamp)
    @account = account
    @stage = stage
    @contact = contact
    @timestamp = timestamp
  end

  attr_reader :account, :stage, :contact, :timestamp
  delegate :organization, to: :account

  def call
    setup_user_properties
    track
  end

  def track
    Heap.track(
      'Set Candidate Stage',
      account.id.to_s,
      properties,
      timestamp
    )
  end

  def setup_user_properties
    Heap.add_user_properties account.id.to_s, user_properties
  end

  def properties
    { name: stage.name, id: stage.id, contact_id: contact.id, bot: 'true' }
  end

  def user_properties
    { name: account.name,
      email: account.email,
      organization_id: organization.id,
      organization_name: organization.name,
      subscription_status: organization.subscription_status }
  end
end
