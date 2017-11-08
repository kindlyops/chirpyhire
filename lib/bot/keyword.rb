class Bot::Keyword
  KEYWORD = %w[START].freeze
  LENGTH = 8

  def initialize(bot, message)
    @bot = bot
    @message = message
  end

  attr_reader :message, :bot
  delegate :body, :contact, to: :message
  delegate :campaigns, to: :bot

  def activated?
    match.present?
  end

  def match
    @match ||= begin
      KEYWORD.detect do |opt_in|
        clean(body).length <= LENGTH && clean(body).include?(opt_in)
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
