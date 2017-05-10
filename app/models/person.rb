class Person < ApplicationRecord
  phony_normalize :phone_number, default_country_code: 'US'
  has_one :candidacy
  has_one :broker_candidacy
  has_one :account, inverse_of: :person
  has_many :broker_contacts
  has_many :contacts
  has_many :conversations, through: :contacts
  has_many :sent_messages,
           class_name: 'Message', foreign_key: :sender_id, inverse_of: :sender
  has_many :received_messages, class_name: 'Message',
                               foreign_key: :recipient_id,
                               inverse_of: :recipient

  belongs_to :zipcode, optional: true

  before_validation :add_nickname

  delegate :inquiry, :availability, :experience, :transportation,
           :certification, :skin_test, :cpr_first_aid, :ideal?, to: :candidacy
  delegate :inquiry, to: :broker_candidacy, prefix: true
  delegate :zipcode, to: :candidacy, prefix: true

  has_attached_file :avatar,
                    styles: { medium: '300x300#', thumb: '100x100#' },
                    default_url: ''
  validates_attachment_content_type :avatar, content_type: %r{\Aimage\/.*\z}

  validates :name, presence: true, unless: :nickname_present?
  validates :nickname, presence: true, unless: :name_present?
  validates :phone_number, presence: true, unless: :name_present?

  def self.candidacy_filter(filter_params)
    return current_scope unless filter_params.present?

    includes(:candidacy)
      .where('candidacies' => filter_params)
  end

  # def self.candidacy_filter(filter_params)
  #   return current_scope unless filter_params.present?

  #   filters = filter_params.map do |k, v|
  #     first = sanitize_sql_array(["\"candidacies\".\"#{k}\" = ?", v])
  #     second = sanitize_sql_array(["\"broker_candidacies\".\"#{k}\" = ?", v])
  #     "#{first} OR #{second}"
  #   end

  #   joins('LEFT JOIN candidacies ON candidacies.person_id = people.id')
  #     .joins('LEFT JOIN broker_candidacies ON broker_candidacies.person_id = people.id')
  #     .where(filters)
  # end

  def self.zipcode_filter(filter_params)
    return current_scope unless filter_params.present?

    filters = filter_params.map do |k, v|
      sanitize_sql_array(["lower(\"zipcodes\".\"#{k}\") = ?", v.downcase])
    end.join(' AND ')

    joins(:zipcode).where(filters)
  end

  def subscribed_to?(organization)
    contacts.where(organization: organization).exists?
  end

  def broker_subscribed_to?(broker)
    broker_contacts.where(broker: broker).exists?
  end

  def actively_subscribed_to?(organization)
    contacts.subscribed.where(organization: organization).exists?
  end

  def subscribed_to(organization)
    contacts.find_by(organization: organization)
  end

  def broker_subscribed_to(broker)
    broker_contacts.find_by(broker: broker)
  end

  def handle
    first_name&.downcase || nickname
  end

  def first_name
    return unless name.present?

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
