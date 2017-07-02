class AlreadySubscribed
  def self.call(contact, message)
    new(contact, message).call
  end

  def initialize(contact, message)
    @message = message
    @contact = contact
  end

  def call
    organization.message(
      sender: Chirpy.person,
      conversation: message.conversation,
      body: already_subscribed
    )
  end

  private

  attr_reader :contact, :message
  delegate :organization, to: :contact
  delegate :recruiter, to: :organization

  def recruiter_signature
    "-#{recruiter.first_name}\n#{organization_signature}" if recruiter.present?
  end

  def organization_signature
    "Team #{organization.name}"
  end

  def signature
    recruiter_signature || organization_signature
  end

  def already_subscribed
    <<~BODY
      Hey there!

      How can we help?

      #{signature}
    BODY
  end
end
