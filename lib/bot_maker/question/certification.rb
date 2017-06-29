class BotMaker::Question::Certification
  def self.call(bot, rank:)
    new(bot, rank: rank).call
  end

  def initialize(bot, rank:)
    @bot = bot
    @rank = rank
  end

  attr_reader :bot, :rank
  delegate :organization, to: :bot

  def call
    question = bot.create_question(body: body, rank: rank)
    responses_and_tags.each do |response, tag|
      follow_up = question.follow_ups.create(response: response)
      follow_up.tags << organization.tags.find_or_create_by(name: tag)
    end
  end

  def body
    <<~QUESTION.strip
      Are you certified?
    QUESTION
  end

  def responses_and_tags
    [
     ['Yes, CNA', 'CNA'], 
     ['Yes, HHA', 'HHA'], 
     ['Yes, PCA', 'PCA'], 
     ['Yes, Other (MA, LPN, RN, etc.)', 'RN, LPN, Other'],
     ['Not yet, but I want to be!', 'No Certification']
    ]
  end
end
