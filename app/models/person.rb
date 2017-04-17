class Person < ApplicationRecord
  phony_normalize :phone_number, default_country_code: 'US'
  has_one :candidacy
  has_many :contacts
  has_many :messages
  belongs_to :zipcode, optional: true

  before_create :add_nickname
  after_save :set_search_content

  delegate :inquiry, :availability, :experience,
           :certification, :skin_test, :cpr_first_aid, :ideal?, to: :candidacy
  delegate :zipcode, to: :candidacy, prefix: true

  has_attached_file :avatar,
                    styles: { medium: '300x300#', thumb: '100x100#' },
                    default_url: '/images/:style/missing.png'
  validates_attachment_content_type :avatar, content_type: %r{\Aimage\/.*\z}

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
    return if name.present? || nickname.present?
    self.nickname = Nickname::Generator.new(self).generate
  rescue Nickname::OutOfNicknames => e
    Rollbar.debug(e)
    self.nickname = 'Anonymous'
  end

  def set_search_content
    contacts.find_each(&:save)
  end
end
