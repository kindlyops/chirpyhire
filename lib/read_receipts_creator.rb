class ReadReceiptsCreator
  def initialize(message, contact)
    @message = message
    @contact = contact
  end

  def self.call(message, contact)
    new(message, contact).call
  end

  def self.wait_until
    2.minutes.from_now
  end

  def wait_until
    self.class.wait_until
  end

  def call
    contact_team_conversations.find_each do |conversation|
      receipt = conversation.read_receipts.find_by(message: message)
      next if receipt.present?

      create_read_receipt(conversation)
    end
  end

  def contact_team_conversations
    team.inbox_conversations.contact(contact)
  end

  def create_read_receipt(conversation)
    receipt = conversation.read_receipts.create!(message: message)
    contact_waiting_job.perform_later(conversation, receipt)
  end

  def contact_waiting_job
    ContactWaitingJob.set(wait_until: wait_until)
  end

  attr_reader :message, :contact
  delegate :team, to: :contact
end
