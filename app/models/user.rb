class User < ActiveRecord::Base
  phony_normalize :phone_number, default_country_code: 'US'
  belongs_to :organization

  has_one :candidate
  has_one :referrer
  has_one :account
  has_many :inquiries
  has_many :tasks
  has_many :answers
  has_many :notifications
  has_many :chirps

  delegate :name, :phone_number, :ideal_profile, to: :organization, prefix: true
  delegate :contact_first_name, to: :organization
  accepts_nested_attributes_for :organization

  scope :with_phone_number, -> { where.not(phone_number: nil) }

  def outstanding_task_for?(taskable)
    outstanding_tasks.where(taskable: taskable).present?
  end

  def outstanding_tasks
    tasks.outstanding
  end

  def outstanding_inquiry
    inquiries.unanswered.first
  end

  def receive_message(body:)
    organization.send_message(to: phone_number, body: body)
  end
end
