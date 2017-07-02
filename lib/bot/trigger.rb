class Bot::Trigger
  KEYWORD = %w[START].freeze

  def initialize(message)
    @message = message
  end

  attr_reader :message
  delegate :body, to: :message

  def activated?
    match.present?
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
