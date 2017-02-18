class Person < ApplicationRecord
  phony_normalize :phone_number, default_country_code: 'US'
  has_one :candidacy
  has_many :leads
  has_many :messages

  before_create :add_nickname
  after_create :create_candidacy

  delegate :outstanding_inquiry, to: :candidacy

  def lead_at?(organization)
    leads.where(organization: organization).exists?
  end

  def lead_at(organization)
    leads.find_by(organization: organization)
  end

  def add_nickname
    self.nickname = Nickname::Generator.new(self).generate
  rescue Nickname::OutOfNicknames => e
    Rails.logger.debug(e)
    self.nickname = 'Anonymous'
  end
end
