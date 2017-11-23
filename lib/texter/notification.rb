class Texter::Notification
  include Texter::Routing

  def initialize(account, conversation)
    @account = account
    @conversation = conversation
  end

  attr_reader :account, :conversation

  def contact_ready_for_review
    message(contact_ready_for_review_view)
  end

  def contact_waiting
    message(contact_waiting_view)
  end

  def contact_ready_for_review_view
    <<~body
      Hi #{account.first_name},

      A new candidate is waiting for you to chat with them.

      Chat with Candidate: #{url}
    body
  end

  def contact_waiting_view
    <<~body
      Hi #{account.first_name},

      A candidate is waiting for your reply. Move quick!

      Chat with Candidate: #{url}
    body
  end

  def url
    inbox_conversation_url(conversation.inbox, conversation)
  end

  def phone_number
    organization.phone_numbers.order(:id).first
  end

  delegate :organization, to: :account

  def message(body)
    return if account.phone_number.blank?

    organization.message(
      recipient: account.person,
      phone_number: phone_number,
      body: body
    )
  end
end
