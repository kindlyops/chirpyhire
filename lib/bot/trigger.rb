class Bot::Trigger
  KEYWORD = %w[START].freeze

  def initialize(bot, message)
    @bot = bot
    @message = message
  end

  attr_reader :message, :bot
  delegate :body, :contact, to: :message
  delegate :campaigns, to: :bot

  def activated?
    no_prior_campaign? && match.present?
  end

  def no_prior_campaign?
    campaigns.merge(contact.campaigns).empty?
  end

  def match
    @match ||= begin
      KEYWORD.detect do |opt_in|
        clean(body).include?(opt_in)
      end
    end
  end

  def clean(string)
    remove_non_alphanumerics(string).strip.upcase
  end

  def remove_non_alphanumerics(string)
    string.gsub(/[^a-z0-9\s]/i, '')
  end
end
