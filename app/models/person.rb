class Person < ApplicationRecord
  phony_normalize :phone_number, default_country_code: 'US'
  has_one :candidacy
  has_many :subscribers
  has_many :messages

  before_create :add_nickname
  after_create :create_candidacy

  delegate :outstanding_inquiry, to: :candidacy

  def subscribed_to?(organization)
    subscribers.where(organization: organization).exists?
  end

  def subscribed_to(organization)
    subscribers.find_by(organization: organization)
  end

  def add_nickname
    self.nickname = Nickname::Generator.new(self).generate
  rescue Nickname::OutOfNicknames => e
    Rails.logger.debug(e)
    self.nickname = 'Anonymous'
  end
end
