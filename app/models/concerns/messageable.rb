module Messageable
  extend ActiveSupport::Concern

  included do
    belongs_to :message
    delegate :user, to: :message
    delegate :organization, to: :user
    delegate :name, to: :sender, prefix: true
    delegate :direction, :body, to: :message
  end

  def attachments
    message.media_instances
  end

  def sender
    @sender ||= begin
      if direction == "outbound-api"
        organization
      elsif direction == "inbound"
        user
      end
    end
  end

  def recipient
    @recipient ||= begin
      if direction == "outbound-api"
        user
      elsif direction == "inbound"
        organization
      end
    end
  end
end
