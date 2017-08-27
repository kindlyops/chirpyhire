class Internal::Logger::SetContactStage
  def self.call(account, contact)
    new(account, contact).call
  end

  def initialize(account, contact)
    @account = account
    @contact = contact
  end

  attr_reader :account, :contact
  delegate :organization, to: :account
  delegate :stage, to: :contact

  def call
    setup_user_properties
    track
  end

  def track
    Heap.track(
      'Set Candidate Stage',
      account.id.to_s,
      { name: stage.name, id: stage.id },
      contact.updated_at.iso8601
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
