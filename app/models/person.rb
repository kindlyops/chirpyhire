class Person < ApplicationRecord
  phony_normalize :phone_number, default_country_code: 'US'
  has_one :candidacy
  has_many :contacts
  has_many :messages

  before_create :add_nickname
  after_create :create_candidacy

  delegate :inquiry, :zipcode, :availability, :experience,
           :certification, :skin_test, :cpr_first_aid, :ideal?, to: :candidacy

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
    full_name || nickname
  end

  private

  def add_nickname
    self.nickname = Nickname::Generator.new(self).generate
  rescue Nickname::OutOfNicknames => e
    Rollbar.debug(e)
    self.nickname = 'Anonymous'
  end
end
