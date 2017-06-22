class Person < ApplicationRecord
  phony_normalize :phone_number, default_country_code: 'US'
  has_one :account, inverse_of: :person
  has_many :contacts

  has_many :sent_messages,
           class_name: 'Message', foreign_key: :sender_id, inverse_of: :sender
  has_many :received_messages, class_name: 'Message',
                               foreign_key: :recipient_id,
                               inverse_of: :recipient

  belongs_to :zipcode, optional: true

  before_validation :add_nickname
  has_attached_file :avatar,
                    styles: { medium: '300x300#', thumb: '100x100#' },
                    default_url: ''
  validates_attachment_content_type :avatar, content_type: %r{\Aimage\/.*\z}

  validates :name, presence: true, unless: :nickname_present?
  validates :nickname, presence: true, unless: :name_present?
  validates :phone_number, presence: true, unless: :name_present?

  def subscribed_to?(teams)
    contacts.where(team: teams).exists?
  end

  def actively_subscribed_to?(teams)
    contacts.subscribed.where(team: teams).exists?
  end

  def subscribed_to(teams)
    contacts.find_by(team: teams)
  end

  def handle
    first_name&.downcase || nickname
  end

  def first_name
    return if name.blank?

    name.split(' ', 2).first
  end

  private

  def add_nickname
    return if persisted? || name.present? || nickname.present?
    self.nickname = Nickname::Generator.new(self).generate
  rescue Nickname::OutOfNicknames => e
    Rollbar.debug(e)
    self.nickname = 'Anonymous'
  end

  def nickname_present?
    nickname.present?
  end

  def name_present?
    name.present?
  end
end
