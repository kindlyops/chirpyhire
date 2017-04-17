class Person < ApplicationRecord
  phony_normalize :phone, default_country_code: 'US'
  has_one :candidacy
  has_many :contacts
  has_many :messages
  belongs_to :zipcode, optional: true
  belongs_to :phone_number, optional: true

  before_create :add_nickname
  after_create :create_candidacy
  after_save :set_search_content

  delegate :inquiry, :availability, :experience,
           :certification, :skin_test, :cpr_first_aid, :ideal?, to: :candidacy
  delegate :zipcode, to: :candidacy, prefix: true

  def phone_number
    (super && super.to_s) || self[:phone]
  end

  def subscribed_to?(organization)
    contacts.where(organization: organization).exists?
  end

  def actively_subscribed_to?(organization)
    contacts.active.where(organization: organization).exists?
  end

  def subscribed_to(organization)
    contacts.find_by(organization: organization)
  end

  def handle
    name || nickname
  end

  private

  def add_nickname
    return if nickname.present?
    self.nickname = Nickname::Generator.new(self).generate
  rescue Nickname::OutOfNicknames => e
    Rollbar.debug(e)
    self.nickname = 'Anonymous'
  end

  def set_search_content
    contacts.find_each(&:save)
  end
end
